//
//  HistoryViewModel.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

public class HistoryViewModel {
    private var history: MarketHistory
    
    var histories: [History] {
        return [History](history.histories.values)
    }
    
    init() {
        self.history = readMarketHistory()
    }
    
    func deleteProduct(product: Product) {
        history.deleteProduct(product: product)
        writeMarketHistory(history: history)
    }
    func appendProduct(product: Product) {
        history.appendProduct(product: product)
        writeMarketHistory(history: history)
    }
}
