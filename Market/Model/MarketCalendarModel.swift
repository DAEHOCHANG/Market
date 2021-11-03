//
//  MarketCalendarModel.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

struct MarketCalendarModel {
    //[date:[Product]] 같은 구조
    private var yearMonth: YearMonth
    private var productsOfDates: [Int:[MarketProduct]] = [:]
}

extension MarketCalendarModel {
    var year: String {
        return yearMonth.year
    }
    var month: String {
        return yearMonth.month
    }
    subscript(date hash:Int) -> [MarketProduct] {
        if productsOfDates[hash] == nil { return [] }
        else { return productsOfDates[hash]! }
    }
}

struct YearMonth :Hashable {
    var year: String
    var month: String
}
