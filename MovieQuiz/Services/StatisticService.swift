//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by user on 03.12.2022.
//

import Foundation

final class StatisticServiceImplementation: StatisticService {
    
    // чтобы каждый раз не обращаться к standard
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    var correct: Int {
        get {
            return userDefaults.integer(forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            return userDefaults.integer(forKey: Keys.total.rawValue)
        }
    }
    
    var date: Date = Date()
    
    // функция сохранения результата с проверкой, что новый результат лучше предыдущих
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        userDefaults.set(self.total + amount, forKey: Keys.total.rawValue)
        userDefaults.set(self.correct + count, forKey: Keys.correct.rawValue)
        
        if bestGame.compare(
            source: GameRecord(correct: count, total: amount, date: date)
        ){
            bestGame = GameRecord(correct: count, total: amount, date: date)
        }
    }
    
    // добавляем модификатор доступа private(set), чтобы соответствовать протоколу
    private(set) var bestGame: GameRecord {
        get { // зачитка результатов
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set { //запись новых данных
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let correctCount = Double(userDefaults.integer(forKey: Keys.correct.rawValue))
            let total = Double(userDefaults.integer(forKey: Keys.total.rawValue))
            return 100*(correctCount/total)
        }
    }
    
    private(set) var gamesCount: Int {
        get {
            let count = userDefaults.integer(forKey: Keys.gamesCount.rawValue)
            return count
        }
        set {
            return userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
}
