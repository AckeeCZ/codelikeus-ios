//
//  RecipesListViewController.swift
//  CodeLikeUs
//
//  Created by Dominik Vesely on 20/03/2018.
//  Copyright © 2018 Petr Šíma. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import ReactiveCocoa

class RecipesListViewController : UITableViewController {
    
    let viewModel : RecipesListViewModelling
    
    init(viewModel: RecipesListViewModelling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //Really apple?
        self.refreshControl = UIRefreshControl()
        if let refreshControl = self.refreshControl{
            refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
        
        setupBindings()
        
    }
    
    func setupBindings() {
        viewModel.recipes.producer.startWithValues { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        refreshControl!.reactive.isRefreshing <~ viewModel.isRefreshing
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refreshAction() {
        viewModel.loadRecipes()
    }
    
    // MARK: TableView Stuff
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = viewModel.recipes.value[indexPath.row].name
        return cell
    }
    
}
