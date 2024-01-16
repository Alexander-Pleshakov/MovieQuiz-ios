//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 16.01.2024.
//

import UIKit


final class MovieQuizPresenter {
    weak var viewController: MovieQuizViewController?
    let questionsAmount = 10
    
    private var currentQuestionIndex = 0
    var correctAnswers = 0
    
    var currentQuestion: QuizQuestion?
    var questionFactory: QuestionFactory?
    var resultAlert: AlertPresenter?
    var statisticService: StatisticService?
    
    
    
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return questionStep
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func buttonYesClicked() {
        didAnswer(isYes: true)
    }
    
    func buttonNoClicked() {
        didAnswer(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
        viewController?.hideLoadingIndicator()
        viewController?.changeButtonState(isEnabled: true)
    }
    
    func showNextQuestionOrResults() {
        if isLastQuestion() {
            guard let statisticService = statisticService else {
                print("statisticService = nil")
                return
            }
            
            statisticService.store(correct: correctAnswers, total: questionsAmount)
            
            let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыгранных квизов:  \(statisticService.gamesCount)
                Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                """
            
            let viewModel = AlertModel(title: "Этот раунд окончен", message: text, buttonText: "Сыграть еще раз") { [weak self] _ in
                guard let self = self else { return }
                resetQuestionIndex()
                correctAnswers = 0
                
                viewController?.showLoadingIndicator()
                questionFactory?.requestNextQuestion()
            }
            resultAlert = AlertPresenter(delegate: viewController)
            resultAlert?.showAlert(model: viewModel)
        } else {
            switchToNextQuestion()
            viewController?.showLoadingIndicator()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
}
