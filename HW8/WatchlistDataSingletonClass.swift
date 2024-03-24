//
//  WatchlistDataSingletonClass.swift
//  HW8
//
//  Created by Aditya on 3/15/24.
//

import Foundation

class WatchlistDataSingletonClass {
    static let shared = WatchlistDataSingletonClass()
    
    private var watchlistData: Set<String> = []
    
    func addToWatchList(stock_data: String) {
        watchlistData.insert(stock_data)
    }
    
    func fetchWatchlist() -> [String] {
        return Array(watchlistData)
    }
}
