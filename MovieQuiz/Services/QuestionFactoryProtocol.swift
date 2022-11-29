//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by user on 29.11.2022.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
