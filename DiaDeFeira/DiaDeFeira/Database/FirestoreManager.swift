//
//  FirestoreManager.swift
//  DiaDeFeira
//
//  Created by Marina Miranda Aranha on 10/09/20.
//  Copyright © 2020 Marina Miranda Aranha. All rights reserved.
//

import Foundation
import Firebase

class FirestoreManager{
    
    let db = Firestore.firestore()
    static let shared = FirestoreManager()
    var marketsArray: [MarketModel] = []
    
    func getMarkets(completion: @escaping ([MarketModel]) -> Void) {

        self.marketsArray = []
        db.collection("campinas").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let market = MarketModel(city: document.data()["city"] as! String,
                                             neighborhood: document.data()["neighborhood"] as! String,
                                             street: document.data()["street"] as! String,
                                             latitude: document.data()["latitude"] as! Double,
                                             longitude: document.data()["longitude"] as! Double,
                                             weekdays: document.data()["weekdays"] as! String,
                                             categories: document.data()["categories"] as! [String])
                    self.marketsArray.append(market)
                    let markets = self.marketsArray
                    completion(markets)
                }
            }
        }
    }
    
}
