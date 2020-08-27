//
//  FavoritesWorker.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 27/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation

class FavoritesWorker {
    func getFavoritesMarkets() -> [MarketModel] {
        var favorites: [MarketModel] = []
        let decoded = UserDefaultsStruct.FavoriteMarkets.favorites
        
        guard decoded.count != 0 else {
            return favorites
        }
        
        //Decode
        do {
           favorites = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! [MarketModel]
        } catch {
            print("Error decoding user defaults data")
        }
        
        return favorites
    }
}
