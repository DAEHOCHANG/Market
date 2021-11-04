//
//  MarketCalendarViewModel.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

public class MarketCalendarsViewModel {
    private var calendar: MarketCalendarModel
    subscript(_ hash:Int)  -> [MarketProduct]{
        return calendar[day: hash]
    }
    
    init(year:String, month:String) {
        calendar = MarketCalendarModel(year: year, month: month)
        calendar = readMarketCalendarModel(calendar: calendar)
    }
    
    func deleteProduct(when day: Int, product: MarketProduct) {
        calendar.deleteProduct(when: day, product: product)
    }
    func appendProduct(when day: Int, product: MarketProduct) {
        calendar.appendProduct(when: day, product: product)
    }
}
