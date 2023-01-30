//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by user on 09.01.2023.
//

import Foundation
import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func didPresentAlert(alert: UIAlertController?)
} 
