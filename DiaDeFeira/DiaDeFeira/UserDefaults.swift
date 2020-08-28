//
//  UserDefaults.swift
//  DiaDeFeira
//
//  Created by Julia Conti Mestre on 26/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation

struct UserDefaultsStruct {
    
    private static let defaults = UserDefaults.standard
    
    //Default
    struct DefaultFavorites {
        static let favorites = Data()
    }
    
    struct FavoriteMarkets {
        static var favorites: Data {
            get {
                return defaults.data(forKey: "FavoritesMarkets") ?? DefaultFavorites.favorites
            }
            set {
                defaults.set(newValue, forKey: "FavoritesMarkets")
                defaults.synchronize()
            }
        }
    }
    
}


