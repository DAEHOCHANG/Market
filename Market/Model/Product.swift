//
//  Product.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

struct MarketProduct: Codable {
    var product: Product
    var productQuantity: Int
}
extension MarketProduct: Equatable {
    static func == (lhs: MarketProduct, rhs: MarketProduct) -> Bool {
        return lhs.product == rhs.product
    }
}

struct Product: Codable {
    var productName: String
    var unit: String = ""
}

extension Product: Hashable {}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.productName == rhs.productName && lhs.unit == rhs.unit
    }
}
