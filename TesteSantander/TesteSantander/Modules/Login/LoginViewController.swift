//
//  LoginViewController.swift
//  TesteSantander
//
//  Created by Felipe Alexander Silva Melo on 28/05/19.
//  Copyright (c) 2019 Felipe Alexander Silva Melo. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Moya
import ViewAnimator
import Hero

protocol LoginDisplayLogic: class {
    func presentStatements(viewModel: Login.Login.ViewModel)
    func displayErrorMessage(message: String)
}

class LoginViewController: BaseViewController, LoginDisplayLogic {
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    static let loginHeaderAnimation = "loginHeaderAnimation"
    
    @IBOutlet weak var userTextField: LoginTextField!
    @IBOutlet weak var passwordTextField: LoginTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAnimations()
        
        userTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25, delay: 0.25, options: [], animations: { [unowned self] in
            self.userTextField.alpha = 1
            self.passwordTextField.alpha = 1
        }, completion: nil)
    }
    
    fileprivate func setupLayout() {
        // Hide error label
        errorLabel.alpha = 0
        
        // Setup login button Layout
        loginButton.layer.cornerRadius = 4
        loginButton.layer.masksToBounds = false
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.warmBlue.cgColor
        
        loginButton.layer.shadowColor = UIColor.warmBlue.cgColor
        loginButton.layer.shadowOpacity = 0.3
        loginButton.layer.shadowRadius = 5
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        
        // Load user saved in memory
        userTextField.text = UserDefaults.standard.string(forKey: Constants.userDefaultsUsername)
    }
    
    fileprivate func setupAnimations() {
        logoImageView.hero.id = SplashViewController.logoAnimation
        loginButton.hero.id = SplashViewController.buttonAnimation
        
        userTextField.alpha = 0
        passwordTextField.alpha = 0
    }
    
    func displayErrorMessage(message: String) {
        indicator.stopAnimating()
        
        errorLabel.text = message
        passwordTextField.text = ""
        guard errorLabel.alpha == 0 else { return }
        
        let slideAnimation = AnimationType.from(direction: .top, offset: 30)
        let zoom = AnimationType.zoom(scale: 0.5)
        errorLabel.animate(
            animations: [zoom, slideAnimation],
            reversed: false,
            initialAlpha: 0,
            finalAlpha: 1
        )
    }
    
    func presentStatements(viewModel: Login.Login.ViewModel) {
        indicator.stopAnimating()
        errorLabel.alpha = 0
        router?.routeToStatements()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        indicator.startAnimating()
        loginButton.hero.id = LoginViewController.loginHeaderAnimation
        
        let userFormFields = Login.UserFormFields(
            user: userTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
        interactor?.login(
            request: Login.Login.Request(userFormFields: userFormFields)
        )
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
}
