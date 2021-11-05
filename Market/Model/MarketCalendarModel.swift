//
//  MarketCalendarModel.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

public struct MarketCalendarModel: Codable{
    //[date:[Product]] 같은 구조
    var yearMonth: YearMonth
    var productsOfDates: [Int:[MarketProduct]] = [:]
    init(year: String, month: String) {
        self.yearMonth = YearMonth(year: year, month: month)
    }
}

extension MarketCalendarModel {
    var year: String {
        return yearMonth.year
    }
    var month: String {
        return yearMonth.month
    }
    subscript(day hash:Int) -> [MarketProduct] {
        if productsOfDates[hash] == nil { return [] }
        else { return productsOfDates[hash]! }
    }
    mutating func deleteProduct(when day: Int, product: MarketProduct) {
        if productsOfDates[day] == nil { return }
        productsOfDates[day]! = productsOfDates[day]!.filter({$0 != product})
    }
    mutating func appendProduct(when day: Int, product: MarketProduct) {
        if productsOfDates[day] == nil {
            productsOfDates[day] = []
        }
        
        for (idx,productVal) in productsOfDates[day]!.enumerated() {
            if productVal == product {
                productsOfDates[day]![idx].productQuantity += product.productQuantity
                return
            }
        }
        productsOfDates[day]!.append(product)
    }
}

struct YearMonth: Hashable, Codable {
    var year: String
    var month: String
}

public func readMarketCalendarModel(calendar data: MarketCalendarModel) -> MarketCalendarModel {
    let year = data.year
    let month = data.month
    do {
        let fileManager = FileManager.default
        let baseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dirURL = baseURL.appendingPathComponent("MarketCalendar")
        let fileURL = dirURL.appendingPathComponent("\(year)&\(month)")
        let data = try String(contentsOf: fileURL, encoding: .utf8).data(using: .utf8)!
        let ret = try JSONDecoder().decode(MarketCalendarModel.self, from: data)
        return ret
    } catch {
        print("read Market Error \(error)")
        return data
    }
}

public func writeMarketCalendarModel(calendar data: MarketCalendarModel) {
    let year = data.year
    let month = data.month
    do {
        let fileManager = FileManager.default
        let baseURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dirURL = baseURL.appendingPathComponent("MarketCalendar")
        if fileManager.fileExists(atPath: dirURL.path) == false {
            try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: false, attributes: nil)
        }
        let fileURL = dirURL.appendingPathComponent("\(year)&\(month)",isDirectory: false)
        let tmpData = try JSONEncoder().encode(data)
        let str = String(data: tmpData, encoding: .utf8)!
        try str.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print("write Market Error \(error)")
    }
}
