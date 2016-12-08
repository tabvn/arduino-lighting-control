//
//  MainTableViewController.swift
//  Lighting Control
//
//  Created by Toan Nguyen Dinh on 12/8/16.
//  Copyright © 2016 tabvn. All rights reserved.
//

import UIKit

import FirebaseDatabase


class MainTableViewController: UITableViewController {

    
    var ref = FIRDatabase.database().reference()
    
    var items: [Device] = []
    
    let cellId: String = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        
        fetchDevies()
        
        
    }
    
    
    func setupViews(){
        
        self.title = "My Home"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DeviceTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func fetchDevies(){
        
        ref.observe(.value, with: { (snapshot: FIRDataSnapshot) in
            
            
            self.items.removeAll()
            
            for chipItem: FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                

                
                let chipId: String = chipItem.key
                
            
                let titles: FIRDataSnapshot = chipItem.childSnapshot(forPath: "titles")
                
                

                
                for device in titles.children.allObjects as! [FIRDataSnapshot]{
                    
                    print("Got device: ", device)
                    
                    let value: NSDictionary = device.value as! NSDictionary
                    
                    let deviceTitle: String = value["title"] as! String
                    let deviceId: String = value["id"] as! String
                    
                    let deviceState: Bool = chipItem.childSnapshot(forPath: "states/\(deviceId)").value as! Bool
                    
                    let newDevice = Device()
                    
                    newDevice.title = deviceTitle
                    newDevice.chipId = chipId
                    newDevice.state = deviceState
                    newDevice.id = deviceId
                    
                    self.items.append(newDevice)
                }
                
            }
            
            
            self.tableView.reloadData()
            
            
            
            
        }) { (err:Error) in
            
            print("got an error: ", err)
        }
        
    
    }

       // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DeviceTableViewCell

    
        let deviceItem: Device = items[indexPath.row]
        
        cell.deviceItem = deviceItem
        cell.title.text = deviceItem.title
        cell.button.isOn = deviceItem.state

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
