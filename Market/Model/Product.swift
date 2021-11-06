//
//  Product.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

struct MarketProduct: Codable {
    var product: tmpProduct
    var productQuantity: Int
    
}
extension MarketProduct: Equatable {
    static func == (lhs: MarketProduct, rhs: MarketProduct) -> Bool {
        return lhs.product == rhs.product
    }
}

struct tmpProduct: Codable{
    var productName: String
    var unit: String = ""
}

extension tmpProduct: Hashable {}

extension tmpProduct: Equatable {
    static func == (lhs: tmpProduct, rhs: tmpProduct) -> Bool {
        return lhs.productName == rhs.productName && lhs.unit == rhs.unit
    }
}
