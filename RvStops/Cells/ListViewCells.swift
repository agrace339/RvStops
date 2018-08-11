//
//  ListViewCells.swift
//  RvStops
//
//  Created by Anna Grace on 8/2/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import UIKit

class ListViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var yelpImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}
