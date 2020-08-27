//
//  SearchManager.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 25/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import UIKit
import MapKit

/// Search bar delegate, search results updating and search bar code in general
extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        searchController?.isActive = false
    }
    
    
    /// Returns true if the text is empty or nil
    func searchBarIsEmpty() -> Bool {
        return searchController?.searchBar.text?.isEmpty ?? true
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.searchDelegate?.update(with: searchText)
    }
    
    
    func isFiltering() -> Bool {
        return searchController?.isActive ?? false && !searchBarIsEmpty()
    }
}
