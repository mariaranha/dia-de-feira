//
//  FavoritesTableViewController.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 27/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    
    let presenter = FavoritesPresenter()
    var favoritesArray: [FavoritesPresenter.FavoritesViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Favoritos"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        favoritesArray = presenter.formatFavorites()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        
        cell.textLabel?.text = favoritesArray[indexPath.row].marketTitle
        cell.detailTextLabel?.text = favoritesArray[indexPath.row].marketSubtitle
        
        return cell
    }


}
