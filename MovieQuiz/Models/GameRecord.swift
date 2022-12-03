//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by user on 03.12.2022.
//

import Foundation

struct GameRecord: Codable {
    let correct: Int // количество правильных ответов
    let total: Int //общее число вопросов
    let date: Date //дата прохождения квиза
    
    func compare(source cmpr: GameRecord) -> Bool {
        if (self.correct < cmpr.correct){
            return true
        } else {
            return false
        }
    }
}
