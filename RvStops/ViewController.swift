//
//  ViewController.swift
//  RvStops
//
//  Created by Anna Grace on 7/24/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //this is a location
        let location = CLLocationCoordinate2DMake(48.88182, 2.43952)
        
        //how zoomed in
        let span = MKCoordinateSpanMake(0.002, 0.002)
        
        //location of map view
        let region = MKCoordinateRegion(center: location, span:span)
        mapView.setRegion(region, animated: true)
        
        //initialize location pointer
        let annotation = MKPointAnnotation()
        
        //placing coord
        annotation.coordinate = location
        
        //naming pointer
        annotation.title = "Pizza Place"
        annotation.subtitle = "Name of Pizza Place"
        
        //adding pointer to map
        mapView.addAnnotation(annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

