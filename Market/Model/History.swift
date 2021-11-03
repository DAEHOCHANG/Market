//
//  History.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation


struct tmpHistory:Hashable {
    var product: tmpProduct
    var count: Int
}

struct MarketHistory {
    var histories: [tmpProduct:tmpHistory] = [:]
}
