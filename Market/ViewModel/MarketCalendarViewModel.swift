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
        writeMarketCalendarModel(calendar: calendar)
    }
    //같은 데이터 중복이 일어날 수 있으니 calendar내부적으로는 이를 해결 해 주어야함
    func appendProduct(when day: Int, product: MarketProduct) {
        calendar.appendProduct(when: day, product: product)
        writeMarketCalendarModel(calendar: calendar)
    }
    func changeCalendar(year: String, month: String) {
        let newCalendar = MarketCalendarModel(year: year, month: month)
        calendar = readMarketCalendarModel(calendar: newCalendar)
    }
}
