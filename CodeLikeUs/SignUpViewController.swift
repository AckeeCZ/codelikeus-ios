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

        let strings = ["code", "like", "us"]
        //imperative programming
        var longUppercaseStrings: [String] = []
        for s in strings {
            if s.count > 2 {
                longUppercaseStrings.append(s.uppercased())
            }
        }
        print(longUppercaseStrings)

        //functional programming
        print(strings.filter { $0.count > 2 }.map { $0.uppercased() })

//        let stringsSignal = SignalProducer(strings)
        let stringsSignal = usernameTextField.reactive.continuousTextValues.map { $0 ?? "" }
        //            .filter { $0.count > 2 }
        //            .map { $0.uppercased() }
//            .reduce("", +)
//            .scan("", +)
            .throttle(0.5, on: QueueScheduler.main)
            .flatMap(.latest)  {
                checkAvailability(username: $0)
                    .retry(upTo: 1)
                    .flatMapError { error -> SignalProducer<String,NoError> in
                        switch error {
                        case let .invalidUsername(reason):
                            return SignalProducer(value: reason)
                        case .networkError:
                            return SignalProducer(value: "network error occurred")
                        }
                }
            }
            .observe(on: UIScheduler())


        messageLabel.reactive.text <~ stringsSignal





    }

    @objc func goToLoginTapped() {
        let loginVC = LoginViewController()
        UIView.transition(from: view, to: loginVC.view, duration: 1, options: [.transitionCrossDissolve], completion: {
            _ in
            UIApplication.shared.keyWindow?.rootViewController = loginVC
        })
    }

}

//func checkAvailability(username: String) -> SignalProducer<String, NoError> {
//    return SignalProducer<Bool, NoError> { observer, _ in
//        DispatchQueue.global(qos: .userInitiated).async {
//            sleep(1)
//            observer.send(value: true)
//        }
//        }.map {
//            "\(username) is \($0 ? "" : "NOT") available."
//    }
//}

enum CheckAvailabilityError: Error {
    case invalidUsername(String)
    case networkError
}

func checkAvailability(username: String) -> SignalProducer<String, CheckAvailabilityError> {
    guard !username.isEmpty else { return SignalProducer(error: .invalidUsername("cant be empty"))  }
    return SignalProducer<Bool, CheckAvailabilityError> { observer, _ in
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            guard arc4random_uniform(3) != 0 else {
                observer.send(error: .networkError)
                return
            }
            guard username.lowercased() != "dv" else {
                observer.send(value: false)
                return
            }
            observer.send(value: true)
        }
        }.map {
            "\(username) is \($0 ? "" : "NOT") available."
    }
}

