//
//  Date.swift
//  Market
//
//  Created by 장대호 on 2021/01/17.
//

import Foundation
// 데이터 구조체 정의, 컨트롤러가 사용할 자료구조 정의


/*
 * Date 관련
 */
var curDate:String = ""
var marketData: Dictionary<String, DataOfDate> = [:]
var historyData: Array<History> = []
let numbering: [Int] = [1,2,3,4,5,6,7,8,9,10]
var selectedRow = 0

public func setDate(date: String) {
    curDate = date
}
public func getDate() -> String{
    return curDate
}

/*
 *  DataOfDate
 *  특정 날에 살것들에 대한 정보를 가진 구조체
 */
struct Product: Codable{
    var name: String
    var quantity: UInt
    var isBought: Bool
    var unit: String = ""
    public func productToString() -> String {
        if unit == ""{
            return "\(name) \(quantity)개"
        } else {
            return "\(name) \(quantity) \(unit)"
        }
    }
}

struct DataOfDate: Codable{
    private var date: String
    private var list: Array<Product>
    var count: Int {
        get {
            return list.count
        }
    }
    init(date:String) {
        self.date = date
        self.list = []
    }
}



extension DataOfDate {
    mutating func setDate(date: Date) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateformatter.string(from: date)
        self.date = dateString
    }
    func getDate() -> String {
        return self.date
    }
   
}


extension DataOfDate {
    public func getList() -> Array<Product> {
        return list
    }
    
    mutating func removeProduct(name: String) {
        list = self.list.filter({
            if name != $0.name {
                return true
            }
            return false
        })
    }
    
    mutating func removeProduct(at: Int) {
        list.remove(at: at)
    }
    
    mutating func append(product: Product) {
        self.list.append(product)
    }
    
    func getProduct(name: String) -> Product?{
        let ret = self.list.filter({
            if name == $0.name {
                return true
            }
            return false
        })
        
        if ret.count == 0 {
            return nil
        }
        return ret[0]
    }
    
    mutating func setProduct(at:Int, to product : Product) {
        self.list[at] = product
    }
}


/*
 * history
 */

struct History: Codable{
    var productName: String
    var count: UInt
    var pr: Int = 0
    public func toString() -> String {
        return "\(productName)"
    }
}

extension Array where Element == History {
    mutating func append(newElement: History) {
        for i in 0..<self.count {
            if self[i].productName == newElement.productName {
                self[i].count += 1
                return
            }
        }
        append(newElement)
    }
}
    

