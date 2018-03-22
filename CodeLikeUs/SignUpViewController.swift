//
//  ViewController.swift
//  CodeLikeUs

//
//  Created by Petr Šíma on 01/02/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {

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
        messageLabel.text = "Sign Up"
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

    }

    @objc func goToLoginTapped() {
        let loginVC = LoginViewController()
        UIView.transition(from: view, to: loginVC.view, duration: 1, options: [.transitionCrossDissolve], completion: {
            _ in
            UIApplication.shared.keyWindow?.rootViewController = loginVC
        })
    }

}
