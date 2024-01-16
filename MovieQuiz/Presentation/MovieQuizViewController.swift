import UIKit


final class MovieQuizViewController: UIViewController {
    
    //MARK: Properties
    
    private var presenter: MovieQuizPresenter!
    
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
        
        presenter = MovieQuizPresenter(viewController: self)
           
        posterImage.layer.cornerRadius = 20
        activityIndicator.hidesWhenStopped = true

        showLoadingIndicator()
    }
    

    //MARK: Functions
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func decoratePosterImage(isCorrect: Bool) {
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] _ in
            guard let self = self else { return }
            
            self.presenter.restartGame()
        }
        let alert = AlertPresenter(delegate: self)
        alert.showAlert(model: model)
    }
    
    //MARK: Actions
    
    @IBAction private func buttonYesClicked(_ sender: Any) {
        presenter.buttonYesClicked()
    }
    
    @IBAction private func buttonNoClicked(_ sender: Any) {
        presenter.buttonNoClicked()
    }
}
