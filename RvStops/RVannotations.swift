//
//  RVannotations.swift
//  RvStops
//
//  Created by Anna Grace on 7/31/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import MapKit

class RVannotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(rvPark: RVpark) {
        self.title = rvPark.name
        self.locationName = rvPark.address
        self.coordinate = rvPark.coordinates
        
        super.init()
    }
}
