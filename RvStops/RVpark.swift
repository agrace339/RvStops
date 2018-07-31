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

struct RVpark {
    let name: String
    let imageURL: String
    let rating: Double
    let distance: Double
    let categories: String
    let address: String
    let ID: String
    let coordinates: CLLocationCoordinate2D
    let index: Int
    
    init(json: JSON, index: Int) {
        self.name = json["name"].stringValue
        self.imageURL = json["image_url"].stringValue
        self.rating = json["rating"].doubleValue
        self.categories = json["categories"]["title"].stringValue
        self.distance = json["distance"].doubleValue
        self.address = json["display_address"].stringValue
        self.ID = json["id"].stringValue
        self.coordinates = CLLocationCoordinate2D(latitude: json["coordinates"]["latitude"].doubleValue, longitude: json["coordinates"]["longitude"].doubleValue)
        self.index = index
    }
}
