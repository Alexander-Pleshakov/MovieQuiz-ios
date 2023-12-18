import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    //MARK: Properties
    
    private let questionsAmount = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var resultAlert: AlertPresenter?
    private var statisticService: StatisticServiceImplementation?
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    //MARK: Outlets
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var questionIndexLabel: UILabel!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        posterImage.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
        
        statisticService = StatisticServiceImplementation()
    }
    
    //MARK: QuestionFactoryDelegate
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    //MARK: Private Functions
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImage.image = step.image
        posterImage.layer.borderWidth = 0
        questionIndexLabel.text = step.questionNumber
        questionLabel.text = step.question
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
        }
        
        posterImage.layer.masksToBounds = true
        posterImage.layer.borderWidth = 8
        posterImage.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            guard let statisticService = statisticService else {
                print("statisticService = nil")
                return
            }
            statisticService.gamesCount += 1
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            statisticService.correct += correctAnswers
            statisticService.total += questionsAmount
            
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов:  \(statisticService.gamesCount)\nРекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))\nСредняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
            
            let viewModel = AlertModel(title: "Этот раунд окончен", message: text, buttonText: "Сыграть еще раз") { [weak self] _ in
                guard let self = self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()
            }
            resultAlert = AlertPresenter(delegate: self)
            resultAlert?.showAlert(model: viewModel)
        } else {
            currentQuestionIndex += 1
            
            questionFactory?.requestNextQuestion()
        }
    }
    
    //MARK: Actions
    
    @IBAction private func buttonYesClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func buttonNoClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
}
