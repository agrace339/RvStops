//
//  RvParkViewController.swift
//  RvStops
//
//  Created by Anna Grace on 8/2/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import UIKit

class RvParkViewController: UIViewController{
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPoster(urlString: RvBusinesses[row].imageURL)
        nameLabel.text = RvBusinesses[row].name
    }
    
    func loadPoster(urlString: String) {
        if let url = URL(string: urlString) {
            if let data = NSData(contentsOf: url) {
                mainImage.image = UIImage(data: data as Data)
            }
        }
        else {
            mainImage.image = #imageLiteral(resourceName: "Yelp_trademark_RGB.eps")
        }
    }
}
