//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by user on 02.12.2022.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresenterDelegate?
    
    func showAlert(result: QuizAlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "ResultAlert"
        let action = UIAlertAction(title: result.buttonText, style: .default, handler: {_ in result.completion() })
        
        alert.addAction(action)
        delegate?.didPresentAlert(alert: alert)
    }
}
