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
    
}

struct tmpProduct: Codable{
    var productName: String
}

extension tmpProduct: Hashable {}

extension tmpProduct: Equatable {
    static func == (lhs: tmpProduct, rhs: tmpProduct) -> Bool {
        return lhs.productName == rhs.productName
    }
}
