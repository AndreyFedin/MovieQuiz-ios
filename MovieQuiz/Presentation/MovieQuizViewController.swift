import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate, MovieQuizViewControllerProtocol {
    private var presenter: MovieQuizPresenter!
    var alertPresenter: AlertPresenter!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.layer.cornerRadius = 20
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        presenter = MovieQuizPresenter(viewController: self)
        
    }
    
    @IBAction func yesButtonDidTap(_ sender: UIButton) {
        presenter.yesButtonDidTap()
    }
    
    @IBAction func noButtonDidTap(_ sender: UIButton) {
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
        noButton.isEnabled = false
        yesButton.isEnabled = false
        self.presenter.alertPresenter = self.alertPresenter
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
