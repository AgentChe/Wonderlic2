//
//  Weak.swift
//  Nursing
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

final class Weak<T> {
    private weak var value: AnyObject?
    
    var weak: T? {
        return value as? T
    }
    
    init<U: AnyObject>(_ value: U) {
        self.value = value
    }
}
