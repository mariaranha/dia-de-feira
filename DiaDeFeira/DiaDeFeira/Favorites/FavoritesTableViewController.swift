//
//  FavoritesTableViewController.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 10/12/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit

protocol SelectedFavoriteMarketDelegate: NSObjectProtocol {
    func marketSelected(market: MarketModel)
}

class FavoritesTableViewController: UITableViewController {
    
    //Table View informations
    var marketsTitle: [String] = []
    var marketsSubtitle: [String] = []
    var favoriteMarkets: [MarketModel] = []
    var markets: [MarketModel] = []
    var mainScreen: HomeViewController!
    weak var selectedFavoriteMarketDelegate: SelectedFavoriteMarketDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getFavoritesMarkets()
    }
    
    func getFavoritesMarkets() {
        var favorites: [MarketModel] = []
        let decoded = UserDefaultsStruct.FavoriteMarkets.favorites
        
        guard decoded.count != 0 else {
            return
        }
        
        //Decode
        do {
           favorites = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MarketModel]
        } catch {
            print("Error decoding user defaults data")
        }
        
        self.favoriteMarkets = favorites
        
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteMarkets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath)
        searchCell.textLabel?.text = favoriteMarkets[indexPath.row].neighborhood
        searchCell.detailTextLabel?.text = favoriteMarkets[indexPath.row].street
        return searchCell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let marketSelected = favoriteMarkets[indexPath.row]
//        selectedFavoriteMarketDelegate?.marketSelected(market: marketSelected)
//    }
}


extension FavoritesTableViewController: SearchResultDelegate {
    func update(with filter: String) {
        favoriteMarkets = markets.filter({(market: MarketModel) -> Bool in return market.neighborhood.lowercased().contains(filter.lowercased())})
        let filterByAddress: [MarketModel] = markets.filter({(market: MarketModel) -> Bool in return market.street.lowercased().contains(filter.lowercased())})
        
        for market in filterByAddress {
            if !favoriteMarkets.contains(market) {
                favoriteMarkets.append(market)
            }
        }
        tableView.reloadData()
    }
    
}
