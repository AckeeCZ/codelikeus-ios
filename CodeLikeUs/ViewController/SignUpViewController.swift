//
//  ViewController.swift
//  CodeLikeUs

//
//  Created by Petr Šíma on 01/02/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa
import enum Result.NoError

protocol SignupFlowDelegate : class {
    func didTapSwitchToLogin()
}

class SignUpViewController: UIViewController {
    
    
    let viewModel : SignupViewModeling
    
    weak var flowDelegate : SignupFlowDelegate?
    
    init(viewModel: SignupViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.isOpaque = true

        let messageLabel = UILabel()
        let usernameDescriptionLabel = UILabel()
        let usernameTextField = UITextField()
        let usernameVStack = UIStackView(arrangedSubviews: [
            usernameDescriptionLabel,
            usernameTextField,
            ])
        let passwordDescriptionLabel = UILabel()
        let passwordTextField = UITextField()
        let passwordVStack = UIStackView(arrangedSubviews: [
            passwordDescriptionLabel,
            passwordTextField,
            ])
        let signUpButton = UIButton()
        let goToLoginButton = UIButton()
        let buttonsHStack = UIStackView(arrangedSubviews: [
            signUpButton,
            goToLoginButton,
            ])
        let vStack = UIStackView(arrangedSubviews: [
            messageLabel,
            usernameVStack,
            passwordVStack,
            buttonsHStack,
            ])

        view.addSubview(vStack)

        let padding = 10
        let vSpacing: CGFloat = 10
        let smallVSpacing: CGFloat = 8
        //both using separate constants and `hSpacing == vSpacing`  are possible
        //let hSpacing: CGFloat = 10
        let smallHSpacing: CGFloat = smallVSpacing


        messageLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 30)
        messageLabel.text = ""
        self.messageLabel = messageLabel
        usernameDescriptionLabel.makeDescription()
        usernameDescriptionLabel.text = "Username"
        usernameTextField.placeholder = "dominikvesely"
        usernameTextField.makeDefault()
        usernameTextField.autocorrectionType = .no
        self.usernameTextField = usernameTextField
        usernameVStack.axis = .vertical
        usernameVStack.spacing = smallVSpacing
        usernameVStack.alignment = .fill
        usernameVStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-2 * padding)
        }
        passwordDescriptionLabel.makeDescription()
        passwordDescriptionLabel.text = "Password"
        passwordTextField.placeholder = "4 or more characters"
        passwordTextField.makeDefault()
        self.passwordTextField = passwordTextField
        passwordVStack.axis = .vertical
        passwordVStack.spacing = smallVSpacing
        passwordVStack.alignment = .fill
        passwordVStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-2 * padding)
        }
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.blue, for: .normal)
        self.signUpButton = signUpButton
        goToLoginButton.setTitle("Go to Login", for: .normal)
        goToLoginButton.setTitleColor(.blue, for: .normal)
        self.goToLoginButton = goToLoginButton
        buttonsHStack.axis = .horizontal
        buttonsHStack.spacing = smallHSpacing
        buttonsHStack.distribution = .fillEqually
        buttonsHStack.snp.makeConstraints { make in
            make.width.equalTo(view.safeAreaLayoutGuide).offset(-2 * padding)
        }
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = vSpacing
        vStack.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(padding)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom).inset(padding)
        }


    }

    weak var messageLabel: UILabel!
    weak var usernameTextField: UITextField!
    weak var passwordTextField: UITextField!
    weak var signUpButton: UIButton!
    weak var goToLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        goToLoginButton.addTarget(self, action: #selector(goToLoginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signupTapped), for: .touchUpInside)
        
        setupBindings()
    }
    
    func setupBindings() {
        
        usernameTextField.reactive.continuousTextValues.map { $0 ?? ""}.observeValues { [weak self] (string) in
            self?.viewModel.changeText(newText: string)
        }
        
        usernameTextField.reactive.text <~ viewModel.text
        
        
        viewModel.signUpAction.errors.observeValues { [unowned self] (error) in
            self.presentErrorAlert(error: error.displayString)
        }
        
        
        viewModel.signUpAction.values.observeValues { [unowned self] _ in
            self.show(UIViewController(), sender: self)
        }
        
        signUpButton.reactive.isEnabled <~ viewModel.signUpAction.isExecuting.map(!)
    }
    
    func presentErrorAlert(error: String) {
        let alert = UIAlertController(title: ":(", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    

    @objc func goToLoginTapped() {
        flowDelegate?.didTapSwitchToLogin()
    }
    
    @objc func signupTapped() {
        viewModel.signUpAction.apply().start()
    }

}





