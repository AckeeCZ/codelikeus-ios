//
//  SignupViewModel.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 20/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import Result

protocol SignupViewModeling {
    
    var text : MutableProperty<String> {get}
    var signUpSucceeded : Signal<(),NoError> {get}
    var signUpErrors : Signal<String,NoError> {get}

    var signUpAction : Action<(),(),CheckAvailabilityError> {get}
        
    func signUp()
    func changeText(newText : String)
}

class SignupViewModel : SignupViewModeling {
    let (signUpErrors, signUpErrorsObserver) = Signal<String,NoError>.pipe()
    let (signUpSucceeded, signUpObserver) = Signal<(),NoError>.pipe()
    let text = MutableProperty<String>("")
    
    lazy var signUpAction : Action<(),(),CheckAvailabilityError> = {
        return Action<(),(),CheckAvailabilityError> {
            return signUpRequest(username: self.text.value).observe(on: UIScheduler())
        }
    }()
    
    init() {
    }
    
    
    func signUp() {
        signUpRequest(username: text.value).observe(on: UIScheduler()).startWithResult { [weak self] (result) in
            switch result {
            case .success( _): self?.signUpObserver.send(value: ())
            case .failure(let error): self?.signUpErrorsObserver.send(value: error.displayString)
            }
        }
    }
    
    func changeText(newText : String) {
        text.value = newText
    }
    
    
}

enum CheckAvailabilityError: Error {
    case invalidUsername(String)
    case networkError
    
    var displayString : String {
        switch self {
        case .invalidUsername(let username): return "Username \(username) is already taken"
        case .networkError: return "Network Error"
        }
    }
}

func signUpRequest(username: String) -> SignalProducer<(), CheckAvailabilityError> {
    guard !username.isEmpty else { return SignalProducer(error: .invalidUsername("cant be empty"))  }
    return SignalProducer<(), CheckAvailabilityError> { observer, _ in
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            guard arc4random_uniform(3) != 0 else {
                observer.send(error: .networkError)
                return
            }
            guard username.lowercased() != "dv" else {
                observer.send(error: .invalidUsername(username))
                return
            }
            observer.send(value: ())
        }
        }
}

