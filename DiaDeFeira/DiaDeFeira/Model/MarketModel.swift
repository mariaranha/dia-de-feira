//
//  MarketModel.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 17/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import MapKit

class MarketModel: NSObject, MKAnnotation {
    
    var city: String
    var  neighborhood: String
    var street: String
    var coordinate: CLLocationCoordinate2D
    
    init(city: String, neighborhood: String,
         street: String, latitudeString: String,
         longitudeString: String) {
        
        self.city = city
        self.neighborhood = neighborhood
        self.street = street
        let latitude = Double(latitudeString)
        let longitude = Double(longitudeString)
        self.coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        super.init()
    }
    
}
