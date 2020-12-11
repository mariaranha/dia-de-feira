//
//  SearchTableViewController.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 25/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import UIKit

protocol SearchResultDelegate: NSObjectProtocol {
    func update(with filter: String)
}


class SearchTableViewController: UITableViewController {
    
    
    var markets: [MarketModel] = []
    var filteredMarkets: [MarketModel] = []
    weak var selectedFavoriteMarketDelegate: SelectedFavoriteMarketDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.markets = JSONManager.loadJSON()
        self.filteredMarkets = self.markets
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMarkets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        searchCell.textLabel?.text = filteredMarkets[indexPath.row].neighborhood
        searchCell.detailTextLabel?.text = filteredMarkets[indexPath.row].street
        return searchCell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMarket = filteredMarkets[indexPath.row]
        selectedFavoriteMarketDelegate?.marketSelected(market: selectedMarket)
    }
}


extension SearchTableViewController: SearchResultDelegate {
    
    
    func update(with filter: String) {
        filteredMarkets = markets.filter({(market: MarketModel) -> Bool in return market.neighborhood.lowercased().contains(filter.lowercased())})
        let filterByAddress: [MarketModel] = markets.filter({(market: MarketModel) -> Bool in return market.street.lowercased().contains(filter.lowercased())})
        
        for market in filterByAddress {
            if !filteredMarkets.contains(market) {
                filteredMarkets.append(market)
            }
        }
        
        // Alphabetic order
        filteredMarkets.sort { $0.neighborhood < $1.neighborhood }
        self.tableView.reloadData()
    }
    
}
