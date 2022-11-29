//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by user on 29.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: class {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
