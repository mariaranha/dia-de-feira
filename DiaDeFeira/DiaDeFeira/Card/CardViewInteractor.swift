//
//  CardViewInteractor.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 24/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import UIKit

class CardViewInteractor {
    
    //Calculate Market Distance
    func haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double) -> Double {
        
        // Converts from degrees to radians
        let degreesToRadians = { (angle: Double) -> Double in
            return (angle / 360) * 2 * .pi
        }
        
        let latitude1 = degreesToRadians(la1)
        let longitude1 = degreesToRadians(lo1)
        let latitude2 = degreesToRadians(la2)
        let longitude2 = degreesToRadians(lo2)
        
        // Earth radius, in meters
        let radius: Double = 6367444.7
        
        let haversin = { (angle: Double) -> Double in
            return (1 - cos(angle))/2
        }
        
        let ahaversin = { (angle: Double) -> Double in
            return 2*asin(sqrt(angle))
        }
        
        return radius * ahaversin(haversin(latitude2 - latitude1) + cos(latitude1) * cos(latitude2) * haversin(longitude2 - longitude1))
    }

}
