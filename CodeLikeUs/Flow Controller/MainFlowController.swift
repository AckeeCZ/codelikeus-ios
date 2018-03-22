//
//  BaseFlowController.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 22/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import UIKit

class MainFlowController {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        didTapSwitchToSignUp()
    }
    
}

extension MainFlowController : SignupFlowDelegate {
    
    func didTapSwitchToLogin() {
        let login = LoginViewController()
        login.flowDelegate = self
        self.navigationController.viewControllers = [login]
    }
    
}

extension MainFlowController : LoginFlowDelegate {
    func didTapSwitchToSignUp() {
        let signup = SignUpViewController(viewModel: SignupViewModel())
        signup.flowDelegate = self
        self.navigationController.viewControllers = [signup]
    }
    
    func didTapReset() {
        let reset = ResetPasswordViewController()
        reset.flowDelegate = self
        self.navigationController.present(UINavigationController(rootViewController: reset), animated: true, completion: nil)
    }
}

extension MainFlowController : ResetPasswordFlowDelegate {
    func didTapDissmiss() {
        self.navigationController.dismiss(animated: true, completion: nil)
    }
}
