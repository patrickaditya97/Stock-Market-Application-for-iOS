//
//  CurrentOrdersViewController.swift
//  HW8
//
//  Created by Aditya on 3/11/24.
//

import UIKit

class CurrentOrdersViewController: UITableViewController {

    var currentOrdersData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        currentOrdersData = CurrentOrdersSingleton.shared.returnCurrentOrder()
        tableView.reloadData()
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

extension CurrentOrdersViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

class OrderTableCell: UITableViewCell {
    @IBOutlet weak var stockNameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var quantityOutlet: UILabel!
    @IBOutlet weak var stockSymbolOutlet: UILabel!
}

extension CurrentOrdersViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentOrdersData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderData = self.currentOrdersData[indexPath[1]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "order_cell", for: indexPath) as! OrderTableCell
        cell.selectionStyle = .none
        
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
                
                cell.backgroundColor = decoded_order_data.action == "buy" ? .systemGreen : .systemRed
                
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
