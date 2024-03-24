//
//  StockMetaDataSingletonClass.swift
//  HW8
//
//  Created by Aditya on 3/10/24.
//

import Foundation

class StockMetaDataSingletonClass {
    static let shared = StockMetaDataSingletonClass()
    
    private var stockMetaData: String?
    
    private init() {}
    
    func setStockMetaData(single_stock_data: String?) {
        stockMetaData = single_stock_data
    }
    
    func getStockMetaData() -> String? {
        return stockMetaData
    }
}
