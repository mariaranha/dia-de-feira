//
//  FavoritesPresenter.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 27/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation

class FavoritesPresenter {
    
    let interactor = FavoritesInteractor()
    
    struct FavoritesViewModel {
        let marketTitle: String
        let marketSubtitle: String
    }
    
    func formatFavorites() -> [FavoritesViewModel] {
        let markets = interactor.getMarkets()
        var favoritesArray: [FavoritesViewModel] = []
        
        for market in markets {
            let favorite = FavoritesViewModel(marketTitle: market.neighborhood,
                                              marketSubtitle: market.street)
            favoritesArray.append(favorite)
        }
        return favoritesArray
    }
}
