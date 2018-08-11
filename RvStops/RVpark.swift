//
//  RVpark.swift
//  RvStops
//
//  Created by Anna Grace on 7/26/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import SwiftyJSON
import MapKit

public struct RVpark {
    let name: String?
    let imageURL: String
    let rating: Double
    let ratingImage: UIImage
    let distance: Double
    let categories: String
    let addressPart1: String
    let addressPart2: String
    let address: String
    let ID: String
    let coordinates: CLLocationCoordinate2D
    let index: Int
    let websiteUrl: String
    
    init(json: JSON, index: Int) {
        self.name = json["name"].stringValue
        self.imageURL = json["image_url"].stringValue
        self.rating = json["rating"].doubleValue
        self.categories = json["categories"]["title"].stringValue
        self.distance = json["distance"].doubleValue
        self.addressPart1 = json["location"]["display_address"][0].stringValue
        self.addressPart2 = json["location"]["display_address"][1].stringValue
        self.address = "\(addressPart1), \(addressPart2)"
        self.ID = json["id"].stringValue
        self.coordinates = CLLocationCoordinate2D(latitude: json["coordinates"]["latitude"].doubleValue, longitude: json["coordinates"]["longitude"].doubleValue)
        self.index = index
        self.websiteUrl = json["url"].stringValue
        
        if rating == 5 {
            ratingImage = #imageLiteral(resourceName: "large_5.png")
        }
        else if rating == 4.5 {
            ratingImage = #imageLiteral(resourceName: "large_4_half.png")
        }
        else if rating == 4 {
            ratingImage = #imageLiteral(resourceName: "large_4.png")
        }
        else if rating == 3.5 {
            ratingImage = #imageLiteral(resourceName: "large_3_half.png")
        }
        else if rating == 3 {
            ratingImage = #imageLiteral(resourceName: "large_3.png")
        }
        else if rating == 2.5 {
            ratingImage = #imageLiteral(resourceName: "large_2_half.png")
        }
        else if rating == 2 {
            ratingImage = #imageLiteral(resourceName: "large_2.png")
        }
        else if rating == 1.5 {
            ratingImage = #imageLiteral(resourceName: "large_1_half.png")
        }
        else if rating == 1 {
            ratingImage = #imageLiteral(resourceName: "large_1.png")
        }
        else if rating == 0 {
            ratingImage = #imageLiteral(resourceName: "large_0.png")
        }
        else{
            ratingImage = #imageLiteral(resourceName: "large_0.png")
        }
    }
}
