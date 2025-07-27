//
//  LogInViewController.swift
//  MentalHealth
//

//

import Foundation
import UIKit
import FirebaseAnalytics

final class LogInViewController: BaseViewController {
    @IBOutlet weak var welcomeBackLabel: SoliULabel! {
        didSet {
            self.welcomeBackLabel.text = .localized(.welcomeBack)
            self.welcomeBackLabel.font = SoliUFont.bold32
        }
    }
    @IBOutlet weak var welcomebackSubLabel: SoliULabel! {
        didSet {
            self.welcomebackSubLabel.text = .localized(.signInPrompt)
            self.welcomebackSubLabel.font = SoliUFont.regular14
        }
    }
    @IBOutlet weak var emailLabel: SoliULabel! {
        didSet {
            self.emailLabel.text = .localized(.email)
            self.emailLabel.font = SoliUFont.regular12
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            self.emailTextField.placeholder = .localized(.enterEmail)
            self.emailTextField.font = SoliUFont.regular12
            self.emailTextField.autocorrectionType = .no
            self.emailTextField.spellCheckingType = .no
        }
    }
    @IBOutlet weak var passwordLabel: SoliULabel! {
        didSet {
            self.passwordLabel.text = .localized(.password)
            self.passwordLabel.font = SoliUFont.regular12
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            self.passwordTextField.placeholder = .localized(.enterPassword)
            self.passwordTextField.font = SoliUFont.regular12
        }
    }
    @IBOutlet weak var rememberMeCheckMark: UIImageView!
    @IBOutlet weak var remembermeLabel: SoliULabel! {
        didSet {
            self.remembermeLabel.text = .localized(.rememberMe)
            self.remembermeLabel.font = SoliUFont.regular10
        }
    }
    @IBOutlet weak var passwordToggleLabel: SoliULabel!

    private lazy var forgotPasswordButton: SoliUButton = {
        let button = SoliUButton()
        button.addTarget(self, action: #selector(navigateToForgotPassword), for: .touchUpInside)
        button.setTitle(.localized(.forgotPassword), for: .normal)
        button.setTitleColor(SoliUColor.soliuBlack, for: .normal)
        button.titleLabel?.font = SoliUFont.regular10
        return button
    }()

    private lazy var signInButton: SoliUButton = {
        let button = SoliUButton()
        button.setTitle(.localized(.signIn), for: .normal)
        button.titleLabel?.font = SoliUFont.black14
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .disabled)
        button.backgroundColor = SoliUColor.newSoliuBlue
        button.addTarget(self, action: #selector(clickedSignInButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveAccountLabel: SoliULabel = {
        let dontHaveAccountLabel = SoliULabel()
        dontHaveAccountLabel.text = .localized(.noAccount)
        dontHaveAccountLabel.font = SoliUFont.regular12
        return dontHaveAccountLabel
    }()

    private lazy var signupButton: SoliUButton = {
        let signupButton = SoliUButton()
        signupButton.setTitle(.localized(.signUp), for: .normal)
        signupButton.titleLabel?.font = SoliUFont.bold12
        signupButton.setTitleColor(SoliUColor.newSoliuBlue, for: .normal)
        signupButton.addTarget(self, action: #selector(navigateToSignUp), for: .touchUpInside)
        return signupButton
    }()
    
    private lazy var dontHaveStackView: SoliUStackView = {
        let dontHaveStackView = SoliUStackView()
        dontHaveStackView.addArrangedSubView([dontHaveAccountLabel, signupButton])
        dontHaveStackView.axis = .horizontal
        dontHaveStackView.spacing = 5
        return dontHaveStackView
    }()

    private lazy var continueAsGuestButton: SoliUButton = {
        let continueAsGuestButton = SoliUButton()
        let titleText = String.localized(.continueAsGuest)
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: SoliUColor.soliuBlack,
            .font: SoliUFont.regular12
        ]
        
        let attributedTitle = NSAttributedString(string: titleText, attributes: attributes)
        continueAsGuestButton.setAttributedTitle(attributedTitle, for: .normal)
        continueAsGuestButton.addTarget(self, action: #selector(tapAsGuest), for: .touchUpInside)
        return continueAsGuestButton
    }()

    
    var rememberMeSelected: Bool = false
    
    private func addPasswordToggleButton() {
        passwordToggleLabel.text = .localized(.show)
        passwordToggleLabel.textColor = SoliUColor.showTitle
        passwordToggleLabel.font = SoliUFont.regular8
        passwordToggleLabel.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePasswordView))
        passwordToggleLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func togglePasswordView(_ sender: SoliUButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if let label = passwordTextField.rightView as? SoliULabel {
            label.text = passwordTextField.isSecureTextEntry ? .localized(.show) : .localized(.hide)
        }
    }
    
    func autoSignIn(email: String, password: String) {
        Task {
            let result = await FBNetworkLayer.shared.logIn(email: email, password: password)

            await MainActor.run {
                switch result {
                case .success:
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    self.showAlert(title: .localized(.success), description: "\(String.localized(.success)) \(LoginManager.shared.getNickName())!")
                    self.navigate(to: HomeTabBarController.self)

                case .failure(let error):
                    self.showAlertWithButton(title: "Auto Sign-In Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func clickedSignInButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.showAlertWithButton(title: .localized(.missingInformationTitle), message: .localized(.missingInformationMessage))
            return
        }

        Task {
            let result = await FBNetworkLayer.shared.logIn(email: email, password: password)

            await MainActor.run {
                switch result {
                case .success:
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")

                    if self.rememberMeSelected {
                        self.saveCredentials(email: email, password: password)
                        self.promptAutoSignIn()
                    } else {
                        self.clearLoginCredentail()
                    }

                    self.navigate(to: HomeTabBarController.self)

                case .failure(let error):
                    self.showAlertWithButton(title: "Sign-in attempt unsuccessful", message: error.localizedDescription)
                }
            }
        }
    }

    @objc private func navigateToForgotPassword() {
        navigate(ForgotPasswordViewController())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadCredentials()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleRememberMe))
        rememberMeCheckMark.addGestureRecognizer(tapGesture)
        rememberMeCheckMark.isUserInteractionEnabled = true
        addPasswordToggleButton()
        
        if UserDefaults.standard.bool(forKey: "autoSignInEnabled"),
           let savedEmail = UserDefaults.standard.string(forKey: "savedEmail") {
            autoSignIn(email: savedEmail, password: KeychainHelper.shared.getPassword(for: savedEmail) ?? "")
        }
    }
    
    @objc private func toggleRememberMe() {
        rememberMeSelected.toggle()
        let imageName = rememberMeSelected ? "checkmark.square.fill" : "square"
        
        let configuration: UIImage.SymbolConfiguration
        if rememberMeSelected {
            configuration = UIImage.SymbolConfiguration(hierarchicalColor: SoliUColor.yesButtonColor)
        } else {
            configuration = UIImage.SymbolConfiguration(hierarchicalColor: SoliUColor.tabBarBorder)
        }
        
        rememberMeCheckMark.image = UIImage(systemName: imageName, withConfiguration: configuration)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        createUnderLineText(button: forgotPasswordButton, text: .localized(.forgotPassword))
        signInButton.layer.cornerRadius = signInButton.bounds.height / 2
        if signInButton.isEnabled {
            signInButton.backgroundColor = SoliUColor.newSoliuBlue
        }
    }

    private func setupUI() {
        view.addSubView([forgotPasswordButton, signInButton, dontHaveStackView, continueAsGuestButton])
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            forgotPasswordButton.centerYAnchor.constraint(equalTo: remembermeLabel.centerYAnchor),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 70),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            dontHaveStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dontHaveStackView.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),

            continueAsGuestButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueAsGuestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    private func saveCredentials(email: String, password: String) {
        UserDefaults.standard.set(email, forKey: "savedEmail")
        KeychainHelper.shared.savePassword(password, for: email)
    }
    
    private func loadCredentials() {
        guard let email = UserDefaults.standard.string(forKey: "savedEmail"),
              let password = KeychainHelper.shared.getPassword(for: email) else { return }

            emailTextField.text = email
            passwordTextField.text = password
            rememberMeSelected = true
            let configuration = UIImage.SymbolConfiguration(hierarchicalColor: SoliUColor.yesButtonColor)
            rememberMeCheckMark.image = UIImage(systemName: "checkmark.square", withConfiguration: configuration)
    }
    
    private func clearLoginCredentail() {
        UserDefaults.standard.set(false, forKey: "autoSignInEnabled")
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        KeychainHelper.shared.deletePassword(for: emailTextField.text ?? "")
    }
    
    private func promptAutoSignIn() {
        let alertController = UIAlertController(title: "Auto Sign-In", message: "Would you like to enable Auto Sign-In for faster login?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            UserDefaults.standard.set(true, forKey: "autoSignInEnabled")
            self.showAlert(title: "Success", description: "Auto Sign-In has been enabled.")
                self.navigate(to: HomeTabBarController.self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
            UserDefaults.standard.set(false, forKey: "autoSignInEnabled")
                self.navigate(to: HomeTabBarController.self)
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func tapAsGuest() {
        let alertVC = ContinueAsGuestAlertViewController()
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        alertVC.delegate = self
        present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func navigateToSignUp() {
        navigate(to: SignUpViewController.self)
    }
}

/// CONTINUE AS GUEST ALERT
extension LogInViewController: ContinueAsGuestAlertViewControllerDelegate {
    func didConfirmContinueAsGuest() {
        clearLoginCredentail()
        LoginManager.shared.continueAsGuest()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        continueAsGuestAnalytics()

        navigate(to: HomeTabBarController.self)
    }

    private func continueAsGuestAnalytics() {
        Analytics.logEvent("continue_as_guest", parameters: [
            "entry_point": "login_screen"
        ])
        Analytics.setUserProperty("true", forName: "is_guest_user")
        Analytics.setUserID(nil)
    }
}

#if DEBUG
extension LogInViewController {
    var testHooks: TestHooks { .init(target: self) }

    struct TestHooks {
        var target: LogInViewController

        var welcomeBackLabel: SoliULabel! { target.welcomeBackLabel }

        var welcomebackSubLabel: SoliULabel! { target.welcomebackSubLabel }

        var emailLabel: SoliULabel! { target.emailLabel }

        var emailTextField: UITextField! { target.emailTextField }

        var passwordLabel: SoliULabel! { target.passwordLabel }

        var passwordTextField: UITextField! { target.passwordTextField }

        var rememberMeCheckMark: UIImageView! { target.rememberMeCheckMark }

        var remembermeLabel: SoliULabel! { target.remembermeLabel }

        var passwordToggleLabel: SoliULabel! { target.passwordToggleLabel }

        var forgotPasswordButton: SoliUButton { target.forgotPasswordButton }

        var signInButton: SoliUButton { target.signInButton }

        var dontHaveAccountLabel: SoliULabel { target.dontHaveAccountLabel }

        var signupButton: SoliUButton { target.signupButton }

        var dontHaveStackView: SoliUStackView { target.dontHaveStackView }

        var continueAsGuestButton: SoliUButton { target.continueAsGuestButton }

        var rememberMeSelected: Bool { target.rememberMeSelected }

        func autoSignIn(email: String, password: String) {
            target.autoSignIn(email: email, password: password)
        }

        func didConfirmContinueAsGuest() { target.didConfirmContinueAsGuest() }
    }
}
#endif
