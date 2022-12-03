//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by user on 03.12.2022.
//

import Foundation

protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}
