//
//  ViewController.swift
//  CodeLikeUs

//
//  Created by Petr Šíma on 01/02/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {

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
        let loginButton = UIButton()
        let goToSignUpButton = UIButton()
        let buttonsHStack = UIStackView(arrangedSubviews: [
            loginButton,
            goToSignUpButton,
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
        messageLabel.text = "Hello"
        self.messageLabel = messageLabel
        usernameDescriptionLabel.makeDescription()
        usernameDescriptionLabel.text = "Username"
        usernameTextField.placeholder = "dominikvesely"
        usernameTextField.makeDefault()
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
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.blue, for: .normal)
        self.loginButton = loginButton
        goToSignUpButton.setTitle("Go to Sign Up", for: .normal)
        goToSignUpButton.setTitleColor(.blue, for: .normal)
        self.goToSignUpButton = goToSignUpButton
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
    weak var loginButton: UIButton!
    weak var goToSignUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        goToSignUpButton.addTarget(self, action: #selector(goToSignUpTapped), for: .touchUpInside)

    }

    @objc func goToSignUpTapped() {
        let signUpVC = SignUpViewController(viewModel: SignupViewModel())
        UIView.transition(from: view, to: signUpVC.view, duration: 1, options: [.transitionCrossDissolve], completion: {
            _ in
            UIApplication.shared.keyWindow?.rootViewController = signUpVC
        })
    }

}
