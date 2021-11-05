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
    var star: Bool
}

public struct MarketHistory: Codable {
    var histories: [tmpProduct:tmpHistory] = [:]
    mutating func deleteProduct(product: tmpProduct) {
        self.histories.removeValue(forKey: product)
    }
}

public func readMarketHistory() -> MarketHistory {
    do {
        let fileManager = FileManager.default
        let baseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = baseURL.appendingPathComponent("History")
        let data = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)!
        let ret = try JSONDecoder().decode(MarketHistory.self, from: data)
        return ret
    } catch {
        print(error)
        return MarketHistory()
    }
}

public func writeMarketHistory(history data: MarketHistory) {
    do {
        let fileManager = FileManager.default
        let baseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = baseURL.appendingPathComponent("History")
        let tmpData = try JSONEncoder().encode(data)
        let str = String(data: tmpData, encoding: .utf8)!
        try str.write(toFile: fileURL.path, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}
