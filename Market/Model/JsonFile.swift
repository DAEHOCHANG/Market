//
//  JsonFile.swift
//  Market
//
//  Created by 장대호 on 2021/01/14.
//

import Foundation
import UIKit

var mData: Dictionary<String,Array<String>> = [:]
var starData: Array<String> = []

public func jsonFileRead() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    do {
        let marketFile = homeDir.appendingPathComponent("MarketData")
        let starFile = homeDir.appendingPathComponent("StarData")
        let marketDatas = try String(contentsOf: marketFile, encoding: .utf8).data(using: .utf8)
        let starDatas = try String(contentsOf: starFile, encoding: .utf8).data(using: .utf8)
        
        let decoder = JSONDecoder()
        mData = try decoder.decode(Dictionary<String,Array<String>>.self, from: marketDatas!)
        starData = try decoder.decode(Array<String>.self, from: starDatas!)
    } catch {
        return
    }
    
}

public func jsonFileWrite() {
    let fileManager = FileManager.default
    let homeDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
       
    do {
        let marketFile = homeDir.appendingPathComponent("MarketData")
        let starFile = homeDir.appendingPathComponent("StarData")
       
        
        let encoder = JSONEncoder()
        try encoder.encode(mData).write(to: marketFile)
        try encoder.encode(starData).write(to: starFile)
    } catch {
        return
    }
}


func forTableViewString(s: String) -> String {
    
    let words = s.split(separator: "/")
    var ret = words[0]
    if words[1] != "_" || words[2] != "_" {
        ret += "(\(words[1])\(words[2]))"
    }
    if words[3] != "_" || words[4] != "_" {
        if words[4] == "_" {
            ret += "\(words[3])개"
        } else if words[3] == "_" {
            ret += "1\(words[4])"
        } else {
            ret += " \(words[3])\(words[4])"
        }
    }
    return String(ret)
}
