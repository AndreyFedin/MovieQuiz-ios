//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by user on 29.11.2022.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
