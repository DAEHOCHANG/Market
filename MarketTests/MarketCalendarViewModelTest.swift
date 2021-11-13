//
//  MarketCalendarViewModel.swift
//  MarketTests
//
//  Created by 장대호 on 2021/11/10.
//
import XCTest
@testable import Market

/**
 품목 추가 단위 테스트
 - 중복된 품목(이름동일, 유닛 동일) 추가 :  잘 되는지
 - 애매한 품목 (이름동일, 유닛 다름) 추가: 다르게 잘 들어가는지
 - 한번에 많은 품목 추가 (100개?)         : 파일이 정상적으로 잘 쓰여지는지
 - 메모리 테스트
 */
class AppendProductTest: XCTestCase {
    let calendar = MarketCalendarsViewModel()
    var day = 0
    
    override func setUpWithError() throws {
        let date = Date()
        let component = Calendar.current.dateComponents([.day], from: date)
        day = component.day!
        let arr = calendar[day]
        for product in arr {
            calendar.deleteProduct(when: day, product: product)
        }
    }
    
    func testOverlapProdcut() {
        let product1 = MarketProduct(product: Product(productName: "고기", unit: "g"), productQuantity: 10)
        let product2 = MarketProduct(product: Product(productName: "고기", unit: "g"), productQuantity: 20)
        
        calendar.appendProduct(when: day, product: product1)
        calendar.appendProduct(when: day, product: product2)
        
        let len = calendar[day].count
        XCTAssertEqual(len, 1, "중복 테스트 에러")
        let quan = calendar[day][0].productQuantity
        XCTAssertEqual(quan, 30, "중복 테스트 에러")
    }
    
    func testAmbiguousProdcut() {
        let product1 = MarketProduct(product: Product(productName: "고기", unit: "g"), productQuantity: 10)
        let product2 = MarketProduct(product: Product(productName: "고기", unit: "근"), productQuantity: 20)
        
        calendar.appendProduct(when: day, product: product1)
        calendar.appendProduct(when: day, product: product2)
        
        let len = calendar[day].count
        XCTAssertEqual(len, 2, "애매한 경우 테스트 에러")
        let quan1 = calendar[day][0].productQuantity
        let quan2 = calendar[day][1].productQuantity
        XCTAssertEqual(quan1, 10, "애매한 경우 테스트 에러")
        XCTAssertEqual(quan2, 20, "애매한 경우 테스트 에러")
    }
    /*
     잠시 중단
    func testManyProdcut() {
        let max = 100
        
        for productName in 1...max {
            let product = MarketProduct(product: Product(productName: String(productName), unit: "g"), productQuantity: 10)
            calendar.appendProduct(when: day, product: product)
        }
        sleep(3)
        let newCalendar = MarketCalendarsViewModel()
        let day1 = calendar[day].count
        let day2 = newCalendar[day].count
        XCTAssertEqual(day1, max, "많이 넣는경우 테스트 에러")
        XCTAssertEqual(day1, day2, "많이 넣는경우 테스트 에러")
    }*/
}

/**
 삭제 테스트
 
 입력 넣기전에 삭제를 진행해 주는데 문제없으며 생각나는 특이 케이스 없음
 */
class DeleteProductTest: XCTestCase {
    
}

/**
 캘린더 변경 테스트
 
 마땅히 테스트 해볼 것이 없음
 다만 메모리 관련해서 테스트해볼것(이건 어떻게 한담)
 */
class ChangeCalendarTest: XCTestCase {
    
}
