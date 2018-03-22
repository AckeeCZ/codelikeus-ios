//
//  DummyCookbookAPIService.swift
//  CodeLikeUsTests
//
//  Created by Dominik Vesely on 22/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import ReactiveSwift
@testable import CodeLikeUs

class DummyCookbookAPIService : CookbookAPIServicing {
    
    func getRecipes() -> SignalProducer<[Recipe], RequestError> {
        return SignalProducer(value: [Recipe(name:"Dummy Receipt")])
    }
    
    
}
