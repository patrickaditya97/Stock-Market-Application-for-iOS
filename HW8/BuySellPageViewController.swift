//
//  BuyPageViewController.swift
//  HW8
//
//  Created by Aditya on 3/10/24.
//

import UIKit

class BuySellPageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldOutlet: UITextField!
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var stockNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    
    var stock_name: String? = nil
    var close_price: Double? = nil
    
    var total_price_value: Double? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let stock_json_string = StockMetaDataSingletonClass.shared.getStockMetaData() {
            do {
                struct StockDataStruct: Decodable {
                    let symbol: String
                    let name: String
                    let low: String
                    let high: String
                    let volume: String
                    let close: String
                    let datetime: String
                    let open: String
                }

                if let jsonData = stock_json_string.data(using: .utf8) {
                    let decoded_stock_data = try JSONDecoder().decode(StockDataStruct.self, from: jsonData)
                    
                    stock_name = decoded_stock_data.name
                    close_price = Double(decoded_stock_data.close)
                    
                    stockNameLabel.text = stock_name
                    qtyLabel.text = String(Int(stepperOutlet.value))
                    textFieldOutlet.text = String(Int(stepperOutlet.value))
                    
                    priceLabel.text = String(format: "$%.2f", close_price!)
                    totalPriceLabel.text = String(format: "$%.2f", close_price!)
                }
            } catch {
                print("Error Decoding data:", error)
            }
        }
    }
    
    @IBAction func stepperController(_ sender: UIStepper) {
        textFieldOutlet.text = String(Int(sender.value))
        qtyLabel.text = String(Int(sender.value))
        
        let totalPriceValue = close_price! * sender.value
        
        totalPriceLabel.text = String(format: "$%.2f", totalPriceValue)
    }
    
    func buySellSupportFunction(actionString: String) {
        if let stock_json_string = StockMetaDataSingletonClass.shared.getStockMetaData() {
            do {
                struct StockDataStruct: Decodable, Encodable {
                    let symbol: String
                    let name: String
                    let low: String
                    let high: String
                    let volume: String
                    let close: String
                    let datetime: String
                    let open: String
                    var action: String?
                    var quantity: String?
                }

                if let jsonData = stock_json_string.data(using: .utf8) {
                    let decoded_stock_data = try JSONDecoder().decode(StockDataStruct.self, from: jsonData)
                    
                    var temp_data = decoded_stock_data
                    temp_data.action = actionString
                    temp_data.quantity = qtyLabel.text
                    
                    let jsonEncoder = JSONEncoder()
                    jsonEncoder.outputFormatting = .prettyPrinted
                    
                    let temp_json_data = try jsonEncoder.encode(temp_data)
                    
                    if let updated_stock_json = String(data: temp_json_data, encoding: .utf8) {
                        CurrentOrdersSingleton.shared.appendCurrentOrder(current_stock_order: updated_stock_json)
                    }
                    
                    if(actionString == "buy") {
                        CurrentOrdersSingleton.shared.changePortfolioValue(with: Double(close_price ?? 0.0), by: Double(temp_data.quantity ?? "1")!, _for: actionString)
                    } else {
                        CurrentOrdersSingleton.shared.changePortfolioValue(with: Double(close_price ?? 0.0), by: Double(temp_data.quantity ?? "1")!, _for: actionString)
                    }
                    
                    let actionConfirmation: UIAlertController = UIAlertController(title: "Action Successful", message: "\(actionString.capitalized) action is successful", preferredStyle: .actionSheet)
                    
                    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .default) { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    actionConfirmation.addAction(okAction)
                    present(actionConfirmation, animated: true)
                }
            } catch {
                print("Error decoding data:", error)
            }
        }
    }
    
    @IBAction func buyStockAction(_ sender: UIButton) {
        buySellSupportFunction(actionString: "buy")
    }
    
    @IBAction func sellStockAction(_ sender: UIButton) {
        buySellSupportFunction(actionString: "sell")
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
