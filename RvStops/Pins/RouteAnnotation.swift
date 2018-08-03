//
//  RouteAnnotation.swift
//  RvStops
//
//  Created by Anna Grace on 7/31/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import MapKit

class RouteAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinates: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinates
        
        super.init()
    }
}
