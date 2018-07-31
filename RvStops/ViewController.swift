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
import Alamofire
import SwiftyJSON
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var startLocationTextField: UITextField!
    
    let manager = CLLocationManager()
    var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    var myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7648, longitude: 0)
    var enRoute = false
    
    var locationAddress:String = ""
    var locationCoords: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7648, longitude: 0)
    
    var yelpAPIurl = "https://api.yelp.com/v3/businesses/search?term=rv-parks&latitude=37.7648&longitude=-145.463"
    
    var RvBusinesses:[RVpark] = []
    var RvBusinessesAnno:[RVannotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gets user's permission for location
        manager.requestWhenInUseAuthorization()
        
        //if approved
        if CLLocationManager.locationServicesEnabled() {
            //load current location (blue dot)
            manager.delegate = self
            manager.activityType = CLActivityType(rawValue: CLActivityType.RawValue(kCLLocationAccuracyBest))!
            
            manager.startUpdatingLocation()
            
            //zoom on current location
            zoomCurrentLocation(location: manager.location != nil ? manager.location! : CLLocation(latitude: 37.7648,longitude:  -122.463), zoom: 0.1)
            
            //getting yelp api
            sendAlamoRequest(url: yelpAPIurl)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
//        print("Annotation selected")
//
//        if let annotation = view.annotation as? RVannotation {
//            print("Your annotation title: \(annotation.title)");
//        }
//    }
    
    //runs everytime user moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let currentLocation = locations[0]
        
        if enRoute {
           // zoomCurrentLocation(location: currentLocation, zoom: 0.01)
        }
        else {
         //   zoomCurrentLocation(location: currentLocation, zoom: span.latitudeDelta)
        }
    }
    
    //focuses on current location of user
    func zoomCurrentLocation(location: CLLocation, zoom: Double){
        span = MKCoordinateSpanMake(zoom, zoom)
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        self.mapView.showsUserLocation = true
        
    }
    
    //turns addresses to Coordinates
    func addressToCoords(address: String) -> CLLocationCoordinate2D {
        var geocoder = CLGeocoder()
        var lat:Double = 0.0
        var lon:Double = 0.0
        
        geocoder.geocodeAddressString(address) {
            placemarks, error in
            let placemark = placemarks?.first
            lat = (placemark?.location?.coordinate.latitude)!
            lon = (placemark?.location?.coordinate.longitude)!
            print("Lat: \(lat), Lon: \(lon)")
        }
        
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    //gets yelp data
    func sendAlamoRequest(url: String){
        var request = URLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        request.setValue("Bearer 49GFmbGCDzHznADJ-YGDYeoULqygpIzlti6dQi0Ht140wC9ZX-e1NazgdieCX0YAgIgKFuYdqBv3RL-Hq6h6wG_Dxt-SkkFoIUqC2xXqyvlgBj0TI_PmZwM5f-FYW3Yx", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //alamo request
        Alamofire.request(request)
            .validate()
            .responseJSON { (response) -> Void in
                switch response.result {
                case .success:
                    print("we're in")
                    if let value = response.result.value{
                        for i in 0...(JSON(value)["businesses"]).count {
                            self.RvBusinesses.append(RVpark(json: JSON(value)["businesses"][i], index: i))
                            
                            let rvAnnotation:RVannotation = RVannotation(rvPark: self.RvBusinesses[i])
                            self.RvBusinessesAnno.append(rvAnnotation)
                            self.mapView.addAnnotation(rvAnnotation)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
    
    //Button to ListView
    @IBAction func listButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toListView", sender: Any?.self)
    }
    
    //When user starts typing
    @IBAction func startAddressTyping(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationAddress = place.formattedAddress!
        
        if locationAddress != "" {
            locationCoords = addressToCoords(address: locationAddress)
        }
        
        yelpAPIurl = "https://api.yelp.com/v3/businesses/search?term=rv-parks&latitude=\(locationCoords.latitude)&longitude=\(locationCoords.longitude)"
        
        sendAlamoRequest(url: yelpAPIurl)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
