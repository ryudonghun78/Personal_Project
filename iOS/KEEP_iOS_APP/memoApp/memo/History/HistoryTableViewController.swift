//
//  HistoryTableViewController.swift
//  memo
//
//  Created by 이효중 on 2017. 10. 16..
//  Copyright © 2017년 이효중. All rights reserved.
//

import UIKit
import Firebase

class HistoryTableViewController: UITableViewController {
    var name : String?
    var email : String?
    var number : String?
    
    var users = [User]()
    
    override func viewDidLoad() {
        fetchUser()
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        
        
    }
    
    //import user list from firebase
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: {(snapshot) in
            
            //import snapshot
            if let dictionary = snapshot.value as? [String:Any]{
                print("dictionary : \(dictionary)")
                let user = User()
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                let queue = DispatchQueue(label: "label")
                queue.async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
        print("successfully ending")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryViewCell
        
        let user = users[indexPath.row]
        
        cell.nameLabel.text = user.name!
        cell.descriptLabel.text = user.email!
        
        
        // Configure the cell...
        
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
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath){
            var index = tableView.indexPathForSelectedRow?.row
        }
        
        if segue.identifier == "showNote" {
            
            let destination = segue.destination as! HistoryDetailViewController
            destination.name = users[(self.tableView.indexPathForSelectedRow?.row)!].name
            destination.email = users[(self.tableView.indexPathForSelectedRow?.row)!].email
            destination.number = users[(self.tableView.indexPathForSelectedRow?.row)!].number
            
        }
    }
    
    
}




