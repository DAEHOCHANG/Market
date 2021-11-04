//
//  History.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation


struct tmpHistory: Hashable, Codable {
    var product: tmpProduct
    var count: Int
    var strat: Bool
}

struct MarketHistory: Codable {
    var histories: [tmpProduct:tmpHistory] = [:]
}

