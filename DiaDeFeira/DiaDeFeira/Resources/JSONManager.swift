//
//  JSONManager.swift
//  DiaDeFeira
//
//  Created by Matheus Oliveira on 25/08/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation

/// This class helps to controll JSON files over the app.
class JSONManager {
    
    
    /// Loads json information and returns it on a MarketsModel array.
    public static func loadJSON() -> [MarketModel] {
        
        do {
            if let bundlePath = Bundle.main.path(forResource: "feiras-sp", ofType: "json") {
                let data = try String(contentsOfFile: bundlePath).data(using: .utf8)
                let jsonData = try JSONDecoder().decode([MarketModel].self, from: data!)
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return []
    }

}
