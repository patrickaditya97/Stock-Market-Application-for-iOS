//
//  PortfolioPageViewController.swift
//  HW8
//
//  Created by Aditya on 3/14/24.
//

import UIKit

class PortfolioPageViewController: UIViewController {

    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var portfolioValueLabel: UILabel!
    
    var portfolioData: [String] = []
    var portfolioValue: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        var portfolioDummyData: [String] = []
        for stock in CurrentOrdersSingleton.shared.returnCurrentOrder() {
            if stock.contains("buy") {
                portfolioDummyData.append(stock)
            }
        }
        
        portfolioData = portfolioDummyData
        portfolioValue = CurrentOrdersSingleton.shared.returnPortfolioValue()
        
        portfolioValueLabel.text = "$\(ceil(portfolioValue*100)/100)"
        
        tableViewOutlet.reloadData()
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

extension PortfolioPageViewController: UITableViewDelegate {
    func tableView(_ tableView:  UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

class PortfolioTableCell: UITableViewCell {
    @IBOutlet weak var stockNameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UILabel!
    @IBOutlet weak var stockSymbolOutlet: UILabel!
}

extension PortfolioPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.portfolioData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.register(PortfolioTableCell.self, forCellReuseIdentifier: "portfolio_cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "portfolio_cell", for: indexPath) as! PortfolioTableCell
        cell.selectionStyle = .none
        
        let orderData = self.portfolioData[indexPath[1]]
        print(orderData)
        do {
            struct order_details_struct: Decodable {
                let symbol: String
                let name: String
                let low: String
                let high: String
                let volume: String
                let close: String
                let datetime: String
                let open: String
                let action: String
                let quantity: String
            }
            
            if let jsonData = orderData.data(using: .utf8) {
                let decoded_order_data = try JSONDecoder().decode(order_details_struct.self, from: jsonData)
                
                cell.stockNameOutlet.backgroundColor = .clear
                cell.stockNameOutlet.text = decoded_order_data.name
                
                cell.priceOutlet.backgroundColor = .clear
                cell.priceOutlet.text = "$\(decoded_order_data.close)"
                
                cell.quantityOutlet.backgroundColor = .clear
                cell.quantityOutlet.text = decoded_order_data.quantity
                
                cell.stockSymbolOutlet.backgroundColor = .clear
                cell.stockSymbolOutlet.text = decoded_order_data.symbol
                
            }
        } catch {
            print("Serializing JSON data failed!", error)
        }
        
        return cell
    }
}
