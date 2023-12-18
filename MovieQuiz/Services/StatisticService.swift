//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 18.12.2023.
//

import Foundation

protocol StatisticService {
    var totalAccuracy: Double {get}
    var gamesCount: Int {get}
    var bestGame: GameRecord {get}
    func store(correct count: Int, total amount: Int)
}
