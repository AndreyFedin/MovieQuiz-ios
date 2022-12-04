import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var alert: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    // В Swift вы можете объявлять свои типы ошибок,
    // подписывать их под протокол Error и использовать
    // для описания нестандартного поведения кода
    private enum FileManagerError: Error {
        case fileDoesntExist
    }
    
    // Заведём отдельную функцию, которая будет возвращать строку,
    // читая файл, находящийся по передаваемому адресу
    private func string(from documentsURL: URL) throws -> String {
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            throw FileManagerError.fileDoesntExist
        }
        return try String(contentsOf: documentsURL)
    }
    
    struct Actor: Codable {
        let id: String
        let image: String
        let name: String
        let asCharacter: String
    }
    struct Movie: Codable {
        let id: String
        let rank: String
        let title: String
        let fullTitle: String
        let year: String
        let image: String
        let crew: String
        let imDbRating: String
        let imDbRatingCount: String
    }
    
    struct Top: Decodable {
        let items: [Movie]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // работа с файлом
        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let jsonFile = "top250MoviesIMDB.json"
        documentsURL.appendPathComponent(jsonFile)
        
        var jsonString: String = ""
        
        do {
            jsonString = try string(from: documentsURL)
        } catch FileManagerError.fileDoesntExist {
            print("Файл по адресу \(documentsURL.path) не существует")
        } catch {
            print("Неизвестная ошибка чтения из файла \(error)")
        }
        
        let data = jsonString.data(using: .utf8)!
        
        do {
            let result = try JSONDecoder().decode(Top.self, from: data)
        } catch {
            print("Failed to parse: \(jsonString)")
        }
        // end работа с файлом
        
        self.imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        self.questionFactory?.requestNextQuestion()
        alert = AlertPresenter(controller: self)
        statisticService = StatisticServiceImplementation()
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        show(quiz: viewModel)
    }
    
    @IBAction func yesButtonDidTap(_ sender: Any) {
        yesButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction func noButtonDidTap(_ sender: Any) {
        noButton.isEnabled = false
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)"
        )
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            
            statisticService?.store(correct: correctAnswers, total: questionsAmount)
            guard let gamesCount = statisticService?.gamesCount else {return}
            guard let bestGame = statisticService?.bestGame else {return}
            guard let totalAccuracy = statisticService?.totalAccuracy else {return}
            
            let text = "Ваш результат: \(correctAnswers)/\(questionsAmount)\nКоличество сыгранных квизов: \(gamesCount)\nРекорд: \(bestGame.correct)/\(bestGame.total) \(bestGame.date.dateTimeString) \nСредняя точность: \(String(format: "%.2f", totalAccuracy))%"
            
            let alertModel = QuizAlertModel(
                title: "Этот раунд окончен!",
                message: text,
                buttonText: "Сыграть ещё раз") {
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    self.questionFactory?.requestNextQuestion()
                }
            alert?.showAlert(result: alertModel)
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
}
