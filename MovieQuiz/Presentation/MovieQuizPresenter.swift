//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by user on 30.12.2022.
//

import UIKit
import Foundation

final class MovieQuizPresenter: QuestionFactoryDelegate {
    weak var viewController: MovieQuizViewController?
    
    var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    var statisticService: StatisticService?
    var alertPresenter: AlertPresenter?
    
    private let questionsAmount: Int = 10
    var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            guard let statisticService = statisticService else {
                return
            }
            
            statisticService.store(correct: correctAnswers, total: self.questionsAmount)
            
            let gamesCount = statisticService.gamesCount
            let bestGame = statisticService.bestGame
            let totalAccuracy = statisticService.totalAccuracy
            
            let text = "Ваш результат: \(correctAnswers)/\(self.questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%"
            
            let alertModel = QuizAlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") {
                    self.restartGame()
                }
            alertPresenter?.showAlert(result: alertModel)
        } else {
            self.switchToNextQuestion()
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func yesButtonDidTap() {
        didAnswer(isYes: true)
    }
    
    func noButtonDidTap() {
        didAnswer(isYes: false)
    }
    
    func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes
        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    func didAnswer(isCorrect: Bool) {
        correctAnswers += 1
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
}
