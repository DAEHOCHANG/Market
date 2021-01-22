//
//  JsonFile.swift
//  Market
//
//  Created by 장대호 on 2021/01/14.
//

import Foundation
import UIKit

public func readMarketData() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
        let marketFile = homeDir.appendingPathComponent("MarketData")
        let marketDatas = try String(contentsOf: marketFile, encoding: .utf8).data(using: .utf8)
        
        let decoder = JSONDecoder()
        marketData = try decoder.decode(Dictionary<String,DataOfDate>.self, from: marketDatas!)
        print(marketData)
    } catch {
        return
    }
}

public func writeMarketData() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
        let marketFile = homeDir.appendingPathComponent("MarketData")
        let encoder = JSONEncoder()
       // try encoder.encode(marketData).write(to: marketFile)
        let data = try encoder.encode(marketData)
        let marketDataString = String(data: data, encoding: .utf8)!
        try marketDataString.write(to: marketFile, atomically: false, encoding: .utf8)
    } catch {
        
        return
    }
    
}

public func readHistoryData() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
       
    do {
        let historyFile = homeDir.appendingPathComponent("HistoryData")
        let histories = try String(contentsOf: historyFile, encoding: .utf8).data(using: .utf8)
        
        let decoder = JSONDecoder()
        historyData = try decoder.decode(Array<History>.self, from: histories!)
        historyData.sort(by: {$0.count > $1.count })
    } catch {
        return
    }
}

public func writeHistoryData() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do {
        let historyFile = homeDir.appendingPathComponent("HistoryData")
        let encoder = JSONEncoder()
        let data = try encoder.encode(historyData)
        let historyString = String(data: data, encoding: .utf8)
        try historyString?.write(to: historyFile, atomically: false, encoding: .utf8)
    } catch {
        return
    }
}
