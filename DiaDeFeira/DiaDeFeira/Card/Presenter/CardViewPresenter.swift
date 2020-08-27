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
        let city: String
        let neighborhood: String
        let street: String
    }
    
    struct FavoriteButtonModel {
        var label: String
        var color: UIColor
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
    
    func formatFavoriteButton(isFavorite: Bool) -> FavoriteButtonModel {
        if isFavorite {
            let button = FavoriteButtonModel(label: "Favorito", color: AppColors.red)
            return button
        } else {
            let button = FavoriteButtonModel(label: "Favoritar", color: AppColors.green)
            return button
        }
    }
    
}
