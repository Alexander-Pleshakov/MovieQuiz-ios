//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 18.12.2023.
//

import Foundation

struct GameRecord: Codable {
    var correct: Int
    var total: Int
    var date: Date
    
    func isGreaterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}
