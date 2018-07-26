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
//import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var startLocationTextField: UITextField!
    @IBOutlet weak var endLocationTextField: UITextField!
    
    let manager = CLLocationManager()
    let yelpAPIurl = URL(string: "https://api.yelp.com/v3/businesses/search?term=RVparks&=location=sanfranciscoUSA")
    var span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    var enRoute = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.activityType = CLActivityType(rawValue: CLActivityType.RawValue(kCLLocationAccuracyBest))!
            
            manager.startUpdatingLocation()
            
            zoomCurrentLocation(location: manager.location != nil ? manager.location! : CLLocation(latitude: 0,longitude: 0), zoom: 0.1)
            
            
            
//            let startAddress = addressToCoords(address: startLocationTextField.text != nil ? startLocationTextField.text! : "")
//
//            let annotation = MKPointAnnotation()
//
//            //placing coord
//            annotation.coordinate = startAddress
//
//            //naming pointer
//            annotation.title = startLocationTextField.text
//
//            //adding pointer to map
//            mapView.addAnnotation(annotation)
//
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //runs everytime user moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let currentLocation = locations[0]
        if enRoute {
            zoomCurrentLocation(location: currentLocation, zoom: 0.01)
        }
        else {
            zoomCurrentLocation(location: currentLocation, zoom: span.latitudeDelta)
        }
    }
    
    //focuses on current location of user
    func zoomCurrentLocation(location: CLLocation, zoom: Double){
        
        span = MKCoordinateSpanMake(zoom, zoom)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
    }
    
    //turns addresses to Coordinates
    func addressToCoords(address: String) -> CLLocationCoordinate2D {
        let geocoder = CLGeocoder()
        var coordinates:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0)
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if(error != nil){
                print("Error", error as Any)
            }
            if let placemark = placemarks?.first {
                coordinates = placemark.location!.coordinate
            }
        })
        
        return coordinates
    }
    
    @IBAction func listButtonPressed(_ sender: Any) {
    }
}

/*//add pointer
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
 */
