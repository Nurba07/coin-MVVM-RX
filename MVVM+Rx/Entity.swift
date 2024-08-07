//
//  Entity.swift
//  MVVM+Rx
//
//  Created by Nurbakhyt on 04.08.2024.
//

import Foundation

struct Coin: Codable {
    var data: [CoinData]
    var timestamp: Int
}

struct CoinData: Codable{
    var id: String?
    var rank: String?
    var symbol: String?
    var name: String?
    var supply: String?
    var priceUsd: String?
    var explorer: String?
}
