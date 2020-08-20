//
//  MarketModel.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 17/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import MapKit

/// Represents a market map annotation model
class MarketModel: NSObject, Decodable {
    
    var city: String
    var  neighborhood: String
    var street: String
    var latitude: Double
    var longitude: Double
    var weekdays: String
    var categories: [String]
    
    init(city: String,
         neighborhood: String,
         street: String,
         latitude: Double,
         longitude: Double,
         weekdays: String,
         categories: [String]) {
        
        self.city = city
        self.neighborhood = neighborhood
        self.street = street
        self.latitude = latitude
        self.longitude = longitude
        self.weekdays = weekdays
        self.categories = categories
        super.init()
    }
    
}
