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
        try encoder.encode(marketData).write(to: marketFile)
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
        try encoder.encode(historyData).write(to: historyFile)
    } catch {
        return
    }
}
