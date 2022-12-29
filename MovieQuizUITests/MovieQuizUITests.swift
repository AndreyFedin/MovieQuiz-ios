//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by user on 29.12.2022.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    // swiftlint:disable:next implicitly_unwrapped_optional
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // это специальная настройка для тестов: если один тест не прошёл,
        // то следующие тесты запускаться не будут; и правда, зачем ждать?
        continueAfterFailure = false
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        
        app.buttons["Yes"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        
        app.buttons["No"].tap()
        
        let secondPoster = app.images["Poster"]
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster)
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Finish Alert"]
        
        XCTAssertTrue(app.alerts["Finish Alert"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["Finish Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Finish Alert"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
