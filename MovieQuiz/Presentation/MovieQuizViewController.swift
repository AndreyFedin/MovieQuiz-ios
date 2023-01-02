import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
    }
    
    @IBAction func yesButtonDidTap(_ sender: UIButton) {
        yesButton.isEnabled = false
        presenter.yesButtonDidTap()
    }
    
    @IBAction func noButtonDidTap(_ sender: UIButton) {
        noButton.isEnabled = false
        presenter.noButtonDidTap()
    }
    
    // MARK: - AlertPresenterDelegate
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            presenter.didAnswer(isCorrect: true)
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.statisticService = self.statisticService
            self.presenter.alertPresenter = self.alertPresenter
            self.presenter.showNextQuestionOrResults()
        }
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        self.presenter.restartGame()
        
        let alertModel = QuizAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") {}
        
        alertPresenter?.showAlert(result: alertModel)
    }
}
