//
//  CurrentOrdersSingleton.swift
//  HW8
//
//  Created by Aditya on 3/11/24.
//

import Foundation

class CurrentOrdersSingleton {
    static let shared = CurrentOrdersSingleton()
    
    private var currentOrdersList: [String] = []
    private var portfolioValue: Double = 0
    
    func appendCurrentOrder(current_stock_order: String?) {
        currentOrdersList.append(current_stock_order!)
    }

    func returnCurrentOrder() -> [String] {
        return currentOrdersList
    }
    
    func changePortfolioValue(with: Double, by: Double, _for: String) {
        if(_for == "buy"){
            portfolioValue += with * by
        } else {
            portfolioValue -= with * by
            if(portfolioValue < 0) {
                portfolioValue = 0
            }
        }
    }
    
    func returnPortfolioValue() -> Double {
        return portfolioValue
    }
}
