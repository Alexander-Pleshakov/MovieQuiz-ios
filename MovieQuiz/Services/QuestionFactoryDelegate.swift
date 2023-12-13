//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 13.12.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
