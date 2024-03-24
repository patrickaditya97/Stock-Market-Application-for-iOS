//
//  StockPageViewController.swift
//  HW8
//
//  Created by Aditya on 3/2/24.
//

import UIKit

class StockPageViewController: UIViewController {
//    let stocksMetaData: [[String: Any]] = [
//        ["name": "Apple Inc.", "symbol": "AAPL", "open": 145.0, "close": 148.25, "day_low": 142, "day_high": 150, "volume": 200_000, "market_cap": "$2.5 Trillion"],
//        ["name": "Microsoft", "symbol": "MSFT", "open": 250.0, "close": 255.75, "day_low": 245, "day_high": 260, "volume": 180_000, "market_cap": "$2 Trillion"],
//        ["name": "Amazon Inc.", "symbol": "AMZN", "open": 3200.0, "close": 3225.50, "day_low": 3180, "day_high": 3250, "volume": 150_000, "market_cap": "$1.8 Trillion"],
//        ["name": "Tesla", "symbol": "TSLA", "open": 650.0, "close": 655.75, "day_low": 640, "day_high": 670, "volume": 100_000, "market_cap": "$900 Billion"],
//        ["name": "Alphabet", "symbol": "GOOGL", "open": 2700.0, "close": 2725.25, "day_low": 2680, "day_high": 2750, "volume": 120_000, "market_cap": "$1.7 Trillion"],
//        ["name": "Facebook", "symbol": "FB", "open": 350.0, "close": 355.50, "day_low": 340, "day_high": 360, "volume": 110_000, "market_cap": "$1.2 Trillion"],
//        ["name" : "Netflix", "symbol" : "NFLX", "open" :400.0 , "close" :405.75 , "day_low":390 , "day_high" :410 , "volume" :95_000 , "market_cap" :"$250 Billion"],
//        ["name" : "NVIDIA", "symbol" : "NVDA", "open" :220.0 , "close" :225.50 , "day_low":215 , "day_high" :230 , "volume" :80_000 , "market_cap" :"$500 Billion"],
//        ["name" : "PayPal", "symbol" : "PYPL", "open" :150.0 , "close" :155.75 , "day_low":145 , "day_high" :160 , "volume" :70_000 , "market_cap" :"$300 Billion"],
//        ["name" : "Alibaba Group", "symbol" :"BABA" , "open":200.0 , "close":205.50 , "day_low":190 , "day_high":210 , "volume":60_000 , "market_cap":"$600 Billion"],
//        ["name" :"Johnson&Johnson" , "symbol":"JNJ" , "open":130.0 , "close":135.25 , "day_low":125 , "day_high":140 , "volume":50_000 , "market_cap":"$400 Billion"],
//        ["name" :"Yelp" , "symbol":"YELP" , "open":40.0 , "close":45.75 , "day_low":35 , "day_high":50 , "volume":40_000 ,"market_cap":"$10 Billion"]
//    ]

    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var dayLowLabel: UILabel!
    @IBOutlet weak var dayHighLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var mktCapLabel: UILabel!
    @IBOutlet weak var buySellButton: UIButton!

    var stockIndex: Int = 0
    var stock_name: String = ""
    var stock_symbol: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        title = stocksMetaData[stockIndex]["name"] as? String
        
//        openLabel.text = "$\(String(stocksMetaData[stockIndex]["open"] as? Double ?? 0.0))"
//        closeLabel.text = "$\(String(stocksMetaData[stockIndex]["close"] as? Double ?? 0.0))"
//        dayLowLabel.text = "$\(String(stocksMetaData[stockIndex]["day_low"] as? Int ?? 0))"
//        dayHighLabel.text = "$\(String(stocksMetaData[stockIndex]["day_high"] as? Int ?? 0))"
//        volumeLabel.text = String(stocksMetaData[stockIndex]["volume"] as? Int ?? 0)
//        mktCapLabel.text = stocksMetaData[stockIndex]["market_cap"] as? String
        
        callApi()
    }
    
    
    func callApi() {
        let api_key = "a2518e3266ab4c35b6b84f296fa8833e"
        let api_string = "https://api.twelvedata.com/time_series?symbol=\(stock_symbol)&interval=1min&apikey=\(api_key)"
        
        let task = URLSession.shared.dataTask(with: URL(string: api_string)!) { [self] (data, res, err) in
            if let error = err {
                print("There was an error! \(error)")
                return
            }
            
            if let stock_data = data {
                do {
                    if let json_serialized = try JSONSerialization.jsonObject(with: stock_data, options: []) as? [String: Any],
                       let json_data = json_serialized["values"] as? [[String: Any]],
                       let stock_meta_data = json_data.first {
                        
                        DispatchQueue.main.async { [self] in
                            title = stock_name
                            
                            openLabel.backgroundColor = UIColor.white
                            openLabel.text = "$\(stock_meta_data["open"]!)"
                            
                            closeLabel.backgroundColor = UIColor.white
                            closeLabel.text = "$\(stock_meta_data["close"]!)"
                            
                            dayLowLabel.backgroundColor = UIColor.white
                            dayLowLabel.text = "$\(stock_meta_data["low"]!)"
                            
                            dayHighLabel.backgroundColor = UIColor.white
                            dayHighLabel.text = "$\(stock_meta_data["high"]!)"
                            
                            volumeLabel.backgroundColor = UIColor.white
                            volumeLabel.text = "\(stock_meta_data["volume"]!)"
                            
                            buySellButton.isEnabled = true
                            
                            do {
                                var stock_data = stock_meta_data
                                stock_data["name"] = stock_name
                                stock_data["symbol"] = stock_symbol
                                
                                let json_data = try JSONSerialization.data(withJSONObject: stock_data, options: .prettyPrinted)
                                if let stock_data_json = String(data: json_data, encoding: .utf8) {
                                    StockMetaDataSingletonClass.shared.setStockMetaData(single_stock_data: stock_data_json)
                                }

                            } catch {
                                print("Error Serializing data!")
                            }
                        }
                        
                    } else {
                        print("Invalid JSON format or missing 'Time Series (Daily)' key")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    @IBAction func addToWatchlistAction(_ sender: UIButton) {
        if let stock_json_string = StockMetaDataSingletonClass.shared.getStockMetaData() {
            WatchlistDataSingletonClass.shared.addToWatchList(stock_data: stock_json_string)
            
            let actionConfirmation: UIAlertController = UIAlertController(title: "Action Successful", message: "Added To Watchlist", preferredStyle: .actionSheet)
            
            let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default)
            
            actionConfirmation.addAction(okAction)
            present(actionConfirmation, animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
