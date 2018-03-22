//
//  ResetPasswordViewController.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 22/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import UIKit

protocol ResetPasswordFlowDelegate : class {
    func didTapDissmiss()
}

class ResetPasswordViewController : UIViewController {
    
    weak var flowDelegate : ResetPasswordFlowDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(didTapDismiss))
    }
    
    @objc func didTapDismiss() {
        flowDelegate?.didTapDissmiss()
    }
}
