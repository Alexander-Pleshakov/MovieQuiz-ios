import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: Properties
    
    
    
    
    
    private let presenter = MovieQuizPresenter()
    
    
    
    //MARK: Outlets
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionIndexLabel: UILabel!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
           
        posterImage.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true
        
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(networkClient: NetworkClient()), delegate: self)
        presenter.statisticService = StatisticServiceImplementation()

        showLoadingIndicator()
        presenter.questionFactory?.loadData()
    }
    
    //MARK: QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
            presenter.didReceiveNextQuestion(question: question)
        }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        if (presenter.questionFactory?.moviesIsEmpty() ?? true) {
            let model = AlertModel(title: "Ошибка загрузки",
                                   message: "Проблемы с API key\nПопробуйте позже",
                                   buttonText: "Ok") { [weak self] _ in
                self?.presenter.questionFactory?.loadData()
            }
            
            let alert = AlertPresenter(delegate: self)
            showLoadingIndicator()
            alert.showAlert(model: model)
            return
        }
        presenter.questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    //MARK: Private Functions
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            
            presenter.resetQuestionIndex()
            presenter.correctAnswers = 0
            
            presenter.questionFactory?.requestNextQuestion()
        }
        let alert = AlertPresenter(delegate: self)
        alert.showAlert(model: model)
    }
    
    func changeButtonState(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    func show(quiz step: QuizStepViewModel) {
        posterImage.image = step.image
        posterImage.layer.borderWidth = 0
        questionIndexLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    func showAnswerResult(isCorrect: Bool) {
        changeButtonState(isEnabled: false)
        
        if isCorrect {
            presenter.correctAnswers += 1
        }
        
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            showLoadingIndicator()
            presenter.showNextQuestionOrResults()
        }
    }
    
    //MARK: Actions
    
    @IBAction private func buttonYesClicked(_ sender: Any) {
        presenter.buttonYesClicked()
    }
    
    @IBAction private func buttonNoClicked(_ sender: Any) {
        presenter.buttonNoClicked()
    }
    
    
}
