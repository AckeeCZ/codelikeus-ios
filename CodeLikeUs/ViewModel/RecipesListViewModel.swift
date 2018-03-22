//
//  RecipesListViewModel.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 20/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import ReactiveSwift
import Firebase


//
//  RecipesListViewModel.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 20/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import ReactiveSwift
import Firebase


protocol RecipesListViewModelling {
    
    var recipes : MutableProperty<[Recipe]> {get}
    var isRefreshing : MutableProperty<Bool> {get}
    
    func loadRecipes()
}

class RecipesListViewModel : RecipesListViewModelling {
    
    let apiService : CookbookAPIServicing
    let recipes = MutableProperty<[Recipe]>([])
    let isRefreshing = MutableProperty<Bool>(false)
    
    
    
    init(apiService: CookbookAPIServicing) {
        self.apiService = apiService
    }
    
    
    func loadRecipes() {
        apiService.getRecipes().on(
            starting: { [weak self] in
                self?.isRefreshing.value = true
            },
            terminated: { [weak self] in
                self?.isRefreshing.value = false
                
        }).startWithResult { [weak self] (result) in
            switch result {
            case .success(let recipes): self?.recipes.value = recipes
            case .failure(_): self?.recipes.value = []
            }
        }
    }
    
    
}

class FirebaseRecipesListViewModel : RecipesListViewModelling {
    
    let isRefreshing = MutableProperty<Bool>(false)
    let recipes = MutableProperty<[Recipe]>([])
    
    
    init() {
    }
    
    
    func loadRecipes() {
        Database.database().reference().observe(event: .value).startWithValues { [weak self] (snapshot) in
            let data = snapshot.value as! [Any]
            self?.recipes.value = data.map { Recipe(name: ($0 as! [String:Any])["name"] as! String )}
            self?.isRefreshing.value = false
        }
    }
    
    
}


