//
//  RVpark.swift
//  RvStops
//
//  Created by Anna Grace on 7/26/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RVpark {
    let name: String
    let imageURL: String
    let rating: Double
    let distance: Double
    let categories: String
    let address: String
    let ID: String
    
    init(json: JSON) {
        self.name = json["businesses"][0]["name"].stringValue
        self.imageURL = json["businesses"][0]["image_url"].stringValue
        self.rating = json["businesses"][0]["rating"].doubleValue
        self.categories = json["businesses"][0]["categories"]["title"].stringValue
        self.distance = json["businesses"][0]["distance"].doubleValue
        self.address = json["businesses"][0]["display_address"].stringValue
        self.ID = json["businesses"][0]["id"].stringValue
    }
}
