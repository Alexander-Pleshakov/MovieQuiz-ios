//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 13.12.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: ((UIAlertAction) -> Void)?
}
