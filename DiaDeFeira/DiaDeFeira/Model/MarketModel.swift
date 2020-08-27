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
class MarketModel: NSObject, Decodable, NSCoding {
    var city: String
    var neighborhood: String
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
    
    func encode(with coder: NSCoder) {
        coder.encode(city, forKey: "city")
        coder.encode(neighborhood, forKey: "neighborhood")
        coder.encode(street, forKey: "street")
        coder.encode(latitude, forKey: "latitude")
        coder.encode(longitude, forKey: "longitude")
        coder.encode(weekdays, forKey: "weekdays")
        coder.encode(categories, forKey: "categories")
    }
    
    required convenience init?(coder: NSCoder) {
        let city = coder.decodeObject(forKey: "city") as! String
        let neighborhood = coder.decodeObject(forKey: "neighborhood") as! String
        let street = coder.decodeObject(forKey: "street") as! String
        let latitude = coder.decodeDouble(forKey: "latitude")
        let longitude = coder.decodeDouble(forKey: "longitude")
        let weekdays = coder.decodeObject(forKey: "weekdays") as! String
        let categories = coder.decodeObject(forKey: "categories") as! [String]
        self.init(city: city,
                  neighborhood: neighborhood,
                  street: street,
                  latitude: latitude,
                  longitude: longitude,
                  weekdays: weekdays,
                  categories: categories)
    }
    
}
