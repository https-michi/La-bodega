import UIKit

class SplashViewController: UIViewController {

    let logoImageView = UIImageView(image: UIImage(named: "LogoLaBodega"))
    let expandingCircle = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupLogo()
        

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.animateExpandingCircle()
        }
    }

    private func setupLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 250),
            logoImageView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }

    private func animateExpandingCircle() {
        let diameter: CGFloat = 10
        expandingCircle.frame = CGRect(x: view.center.x - diameter / 2,
                                       y: view.center.y - diameter / 2,
                                       width: diameter,
                                       height: diameter)
        expandingCircle.backgroundColor = .black
        expandingCircle.layer.cornerRadius = diameter / 2
        view.addSubview(expandingCircle)
        view.bringSubviewToFront(logoImageView)

        UIView.animate(withDuration: 1.5, animations: {
            let maxDimension = max(self.view.bounds.width, self.view.bounds.height) * 2
            self.expandingCircle.frame = CGRect(x: self.view.center.x - maxDimension / 2,
                                                y: self.view.center.y - maxDimension / 2,
                                                width: maxDimension,
                                                height: maxDimension)
            self.expandingCircle.layer.cornerRadius = maxDimension / 2
        }, completion: { _ in
            self.fadeOutAndTransition()
        })
    }

    private func fadeOutAndTransition() {
        UIView.animate(withDuration: 1.0, animations: {
            self.expandingCircle.alpha = 0
            self.logoImageView.alpha = 0
        }, completion: { _ in
            self.goToLogin()
        })
    }

    private func goToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        loginVC.modalTransitionStyle = .crossDissolve
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
}
