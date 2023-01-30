//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by user on 01.01.2023.
//

import UIKit
protocol AlertPresenterDelegate: AnyObject {
    func didPresentAlert(alert: UIAlertController?)
}
