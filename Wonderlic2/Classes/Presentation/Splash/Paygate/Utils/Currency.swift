//
//  Currency.swift
//  CodeChallenge
//
//  Created by Андрей Чернышев on 19.03.2024.
//

import Foundation

struct Currency {
    enum LTRCurrency: String, CaseIterable {
        case USD = "USD"
    }
    
    private let iapProduct: IAPProduct
    private let div: Double
    
    init(iapProduct: IAPProduct, div: Double = 1) {
        self.iapProduct = iapProduct
        self.div = div
    }
    
    func formatted() -> String? {
        let currency = iapProduct.original.priceLocale.currency?.identifier ?? ""
        let priceLocale = iapProduct.original.priceLocale
        let priceValue = NSDecimalNumber(decimal: iapProduct.original.price.decimalValue)
        
        let priceDiv = priceValue.dividing(by: NSDecimalNumber(value: div))
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        formatter.maximumFractionDigits = priceDiv.doubleValue.truncatingRemainder(dividingBy: 1) > 0 ? 2 : 0
        formatter.roundingMode = .halfUp
        formatter.currencyCode = currency
        
        let currencySymbol = formatter.currencySymbol ?? currency
        
        formatter.currencyCode = ""
        formatter.currencySymbol = ""
        
        guard let resultPrice = formatter.string(from: priceDiv) else {
            return nil
        }
        
        let cleanedPrice = resultPrice.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let ltrCurrencies = LTRCurrency.allCases.map { $0.rawValue }
        
        if ltrCurrencies.contains(currency) {
            return String(format: "%@%@", currencySymbol, cleanedPrice)
        } else {
            return String(format: "%@%@", cleanedPrice, currencySymbol)
        }
    }
}
