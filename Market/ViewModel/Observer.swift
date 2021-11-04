//
//  observer.swift
//  Market
//
//  Created by 장대호 on 2021/11/04.
//

import Foundation

class Oservable<T> {
    private var listener: ((T) -> Void)?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    init(_ value: T) {
        self.value = value
    }
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        self.listener = closure
    }
}
