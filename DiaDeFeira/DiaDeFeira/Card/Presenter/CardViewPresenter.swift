//
//  CardViewPresenter.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 24/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import UIKit

class CardViewPresenter {
    
    struct CardViewModel {
        let marketTitle: String
        let distance: String
        let weekdays: String
        var city: String
        var neighborhood: String
        var street: String
    }
    
    func formatCard(market: MarketModel, distance: Double) -> CardViewModel {
        let marketTitle = "Feira \(market.neighborhood)"
        let distanceLabel = String(format: "Feira Livre %.1f km", distance)
        
        let card = CardViewModel(marketTitle: marketTitle,
                                 distance: distanceLabel,
                                 weekdays: market.weekdays,
                                 city: market.city,
                                 neighborhood: market.neighborhood,
                                 street: market.street)
        
        return card
    }
    
}
