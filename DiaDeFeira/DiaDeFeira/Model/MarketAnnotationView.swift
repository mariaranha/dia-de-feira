//
//  MarketAnnotationView.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 20/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import MapKit

class MarketAnnotationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
    
            canShowCallout = false
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            glyphImage = UIImage(named: "marketAnnotation")
            markerTintColor = AppColors.red
            
        }
    }
}
