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
extension HomeViewController: UISearchResultsUpdating, UISearchControllerDelegate, SelectedFavoriteMarketDelegate {
        
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
    
    //Move to the market selected pin and show card - SEARCH BAR
    func marketSelected(market: MarketModel) {
        
        //Change day filter selection to none
        for button in buttonsArray {
            button.isSelected = false
            button.backgroundColor = .clear
        }
        
        //Close search results
        self.searchController?.isActive = false
        
        //Remove all pins
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        //Add pin of the selected market
        let annotation = MKPointAnnotation()
        annotation.title = market.neighborhood
        annotation.subtitle = market.street
        annotation.coordinate = CLLocationCoordinate2D(latitude: market.latitude, longitude: market.longitude)
        self.mapView.addAnnotation(annotation)
        
        let pin = annotation.coordinate
        var location = CLLocation()
        
        selectedPinCoordinate = pin
        
        let latitude = pin.latitude
        let longitude = pin.longitude
        location = CLLocation(latitude: latitude, longitude: longitude)
        
        //Select the pin on the map
        let selectedPin = self.mapView.annotations
        
        for pin in selectedPin {
            mapView.selectAnnotation(pin, animated: true)
        }
        
        //function center on map location modified
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 1500,
                                                  longitudinalMeters: 1500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
