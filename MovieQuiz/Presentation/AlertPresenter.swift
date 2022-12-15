//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by user on 02.12.2022.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak private var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func showAlert(result: QuizAlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(
            title: "Сыграть еще раз",
            style: .default, handler: {_ in result.completion() }
        )
        
        alert.addAction(action)
        controller?.present(alert, animated: true, completion: nil )
    }
    
}
