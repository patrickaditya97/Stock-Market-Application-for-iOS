//
//  ViewController.swift
//  HW8
//
//  Created by Aditya on 2/28/24.
//

import UIKit

class TableViewController: UITableViewController {

    var Stock_Data: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stocks"
        // Do any additional setup after loading the view.
        
        let url_string = "https://api.twelvedata.com/stocks?country=United States"
        callAPI(url_string: url_string)
    }
    
    
    func callAPI(url_string: String) {
        let task = URLSession.shared.dataTask(with: URL(string: url_string)!) { (data, res, err) in
            if let error = err {
                print("There was an error! \(error)")
                return
            }
            
            if let stock_data = data {
                do {
                    if let json_serialized = try JSONSerialization.jsonObject(with: stock_data, options: []) as? [String: Any],
                       let json_data = json_serialized["data"] as? [[String: Any]] {
                        
                        var count = 0
                        for stock in json_data {
                            if count < 30 {
                                count += 1
                                self.Stock_Data.append(stock)
                            } else {
                                break
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("Invalid JSON format or missing 'data' key")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}

extension TableViewController {
    override func tableView(_ tableView:  UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoardMain = UIStoryboard(name: "Main", bundle: nil)
        
        if let stockPageViewController = storyBoardMain.instantiateViewController(identifier: "StockPageViewController") as? StockPageViewController {
            guard let stockData = self.Stock_Data[indexPath[1]] as? [String: Any] else {
                return
            }


            stockPageViewController.stockIndex = indexPath[1]
            stockPageViewController.stock_symbol = stockData["symbol"] as! String
            stockPageViewController.stock_name = stockData["name"] as! String
            navigationController?.pushViewController(stockPageViewController, animated: true) // Push the destination view controller
        }
    }
}

class StockTableCell: UITableViewCell {
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockSymbolLabel: UILabel!
//    @IBOutlet weak var stockPriceLabel: UILabel!
//    @IBOutlet weak var stockCentChangeLabel: UILabel!
    @IBOutlet weak var stockTickerImage: UIImageView!
}

extension TableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Stock_Data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stockData = self.Stock_Data[indexPath[1]] as? [String: Any] else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Label Cell", for: indexPath) as! StockTableCell

        cell.stockNameLabel.backgroundColor = UIColor.clear
        cell.stockNameLabel.text = stockData["name"]! as? String
        
        cell.stockSymbolLabel.backgroundColor = UIColor.clear
        cell.stockSymbolLabel.text = stockData["symbol"]! as? String
        
        let imageUrlString = "https://picsum.photos/240"
        if let ulr = URL(string: imageUrlString) {
            let task = URLSession.shared.dataTask(with: ulr) { (data, response, error) in
                if let img_data = data {
                    if let img_obj = UIImage(data: img_data) {
                        DispatchQueue.main.async {
                            cell.stockTickerImage.image = img_obj
                        }
                    }
                }
            }
            task.resume()
        }
        
        return cell
    }
}
