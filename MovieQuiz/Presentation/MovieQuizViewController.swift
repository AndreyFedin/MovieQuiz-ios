import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenter?
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        self.imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
    @IBAction func yesButtonDidTap(_ sender: UIButton) {
        yesButton.isEnabled = false
        presenter.yesButtonDidTap()
    }
    
    @IBAction func noButtonDidTap(_ sender: UIButton) {
        noButton.isEnabled = false
        presenter.noButtonDidTap()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderWidth = 0
        
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.borderWidth = 8
        self.imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true // говорим, что индикатор загрузки скрыт
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        self.presenter.restartGame()
        
        let alertModel = QuizAlertModel(
            title: "Ошибка",
            message: message,
            buttonText: "Попробовать еще раз") {}
        
        self.alertPresenter?.showAlert(result: alertModel)
    }
    
    func didPresentAlert(alert: UIAlertController?) {
        guard let alert = alert else {
            return
        }
        DispatchQueue.main.async {[weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
