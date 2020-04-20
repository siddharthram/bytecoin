//
//  CoinValue.swift
//  ByteCoin
//
//  Created by Siddharth Ram on 4/19/20.
//  Copyright © 2020 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable{
    let rates: [CoinRow]
}


struct CoinRow: Codable{
    let time: String
    let asset_id_quote: String
    let rate: Double
}
