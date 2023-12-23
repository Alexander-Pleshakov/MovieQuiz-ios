//
//  AlertPresentor.swift
//  MovieQuiz
//
//  Created by Александр Плешаков on 13.12.2023.
//

import UIKit

final class AlertPresenter {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: model.title, style: .default, handler: model.completion)
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
