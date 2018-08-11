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
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var yelpImage: UIImageView!
    
    var imageHeight: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPoster(urlString: RvBusinesses[row].imageURL)
        nameLabel.text = RvBusinesses[row].name
        if nameLabel.text! == ""{
            nameLabel.text = "No Nombre"
        }

        ratingImage.image = RvBusinesses[row].ratingImage
        
        websiteButton.layer.cornerRadius = 20
        websiteButton.layer.masksToBounds = true
        websiteButton.layer.borderWidth = 1
        websiteButton.layer.borderColor = UIColor.black.cgColor
        
        mainImage.layer.cornerRadius = 20
        mainImage.layer.masksToBounds = true
        mainImage.layer.borderWidth = 1
        mainImage.layer.borderColor = UIColor.black.cgColor
        
        yelpImage.image = #imageLiteral(resourceName: "yelpLogo.png")
    }
    
    func loadPoster(urlString: String) {
        if let url = URL(string: urlString) {
            if let data = NSData(contentsOf: url) {
                mainImage.image = UIImage(data: data as Data)
                imageHeight = (mainImage.image?.size.height)!
                
                let screenSize: Double = Double(UIScreen.main.bounds.width - 50.0)
                mainImage.frame = CGRect(x: 25.0, y: 25.0, width: screenSize, height: Double(imageHeight))
            }
        }
        else {
            mainImage.image = #imageLiteral(resourceName: "no_pic.png")
        }
    }
    @IBAction func websiteButtonPressed(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: RvBusinesses[row].websiteUrl)!)
    }
}
