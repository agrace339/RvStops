//
//  ListViewController.swift
//  RvStops
//
//  Created by Anna Grace on 8/2/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import UIKit

public var row = 0

class ListViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var listViewTable: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let i = RvBusinesses.count
        return i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listViewTable.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! ListViewCell
        cell.nameLabel.text = RvBusinesses[indexPath.row].name
        cell.addressLabel.text = RvBusinesses[indexPath.row].address
        
        print("Address: \(RvBusinesses[indexPath.row].address)")
        
        cell.yelpImage.image = #imageLiteral(resourceName: "yelpLogo.png")
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
      //  self.performSegue(withIdentifier: "toRV", sender: self)
    }
}
    

