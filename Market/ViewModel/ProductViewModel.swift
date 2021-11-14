//
//  ProductViewModel.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation


class ProductViewModel {
    var product: MarketProduct
    init(productName: String) {
        product =  MarketProduct(product: tmpProduct(productName: productName), productQuantity: 1)
    }
    init(productName: String, quantity: Int ) {
        product =  MarketProduct(product:  tmpProduct(productName: productName), productQuantity: quantity)
    }
    init() {
        product = MarketProduct(product: tmpProduct(productName: ""), productQuantity: 0)
    }
    func nameChange(newName: String) {
        product.product.productName = newName
    }
    func quantityChange(newQuan: Int) {
        product.productQuantity = newQuan
    }
}
