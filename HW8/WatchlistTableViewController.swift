//
//  WatchlistTableViewController.swift
//  HW8
//
//  Created by Aditya on 3/15/24.
//

import UIKit

class WatchlistTableCell: UITableViewCell {
    @IBOutlet weak var stockNameOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var stockSymbolOutlet: UILabel!
}

class WatchlistTableViewController: UITableViewController {

    var watchlistData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        watchlistData = WatchlistDataSingletonClass.shared.fetchWatchlist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        watchlistData = WatchlistDataSingletonClass.shared.fetchWatchlist()
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return watchlistData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let watchlist_data = watchlistData[indexPath[1]]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchlist_cell", for: indexPath) as! WatchlistTableCell
        cell.selectionStyle = .none
        
        do {
            struct watchlist_details_struct: Decodable {
                let symbol: String
                let name: String
                let low: String
                let high: String
                let volume: String
                let close: String
                let datetime: String
                let open: String
            }
            
            if let jsonData = watchlist_data.data(using: .utf8) {
                let decoded_watchlist_data = try JSONDecoder().decode(watchlist_details_struct.self, from: jsonData)
                
                cell.stockNameOutlet.backgroundColor = .clear
                cell.stockNameOutlet.text = decoded_watchlist_data.name
                
                cell.priceOutlet.backgroundColor = .clear
                cell.priceOutlet.text = "$\(decoded_watchlist_data.close)"
                
                cell.stockSymbolOutlet.backgroundColor = .clear
                cell.stockSymbolOutlet.text = decoded_watchlist_data.symbol
                
            }
        } catch {
            print("Serializing JSON data failed!", error)
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
