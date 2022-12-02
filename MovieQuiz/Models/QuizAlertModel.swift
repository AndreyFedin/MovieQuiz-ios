//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by user on 02.12.2022.
//

import Foundation

struct QuizAlertModel {
    let title: String
    let message: String
    let buttonText: String
    var completion:() -> Void
}
