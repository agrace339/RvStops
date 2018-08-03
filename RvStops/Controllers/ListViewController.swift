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
    //    var integer = RvBusinesses.count -1 
        return RvBusinesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "listCell")
        cell.textLabel?.text = RvBusinesses[indexPath.row].name
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        row = indexPath.row
        self.performSegue(withIdentifier: "toRV", sender: self)
    }
}
    

