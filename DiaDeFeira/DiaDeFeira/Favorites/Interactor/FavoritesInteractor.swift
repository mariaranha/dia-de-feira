//
//  FavoritesInteractor.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 27/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation

class FavoritesInteractor {
    let worker = FavoritesWorker()
    
    func getMarkets() -> [MarketModel] {
        let favorites = worker.getFavoritesMarkets()
        return favorites
    }
    
    func findMarketWithCoordinates(latitude: Double, longitude: Double) -> MarketModel {
        let favorites = getMarkets()
        var marketFound: MarketModel!
        
        for market in favorites {
            if market.latitude == latitude && market.longitude == longitude {
                marketFound = market
                break
            }
        }
        
        return marketFound
    }
}
