//
//  Product.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

struct MarketProduct {
    var product: tmpProduct
    var productQuantity: Int
}

struct tmpProduct{
    var productName: String
}

extension tmpProduct: Hashable {}

extension tmpProduct: Equatable {
    static func == (lhs: tmpProduct, rhs: tmpProduct) -> Bool {
        return lhs.productName == rhs.productName
    }
}
