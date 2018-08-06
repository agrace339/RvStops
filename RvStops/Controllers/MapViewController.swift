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

public var RvBusinesses:[RVpark] = []

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    //outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var startLocationTextField: UITextField!
    @IBOutlet weak var focusButton: UIButton!
    @IBOutlet weak var yelpImage: UIImageView!
    
    //location variable
    let manager = CLLocationManager()
    var span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
    var userLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7648, longitude: 0)
    var focused = false
    
    //destiniation info
    var locationAddress:String = ""
    var locationCoords: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    //yelpURL
    var yelpAPIurl = "https://api.yelp.com/v3/businesses/search?term=rv-parks&latitude=37.7648&longitude=-145.463&radius=10000"
    
    //All parks and pins
    var RvBusinessesAnno:[MKPointAnnotation] = []
    var RvBusinessesName:[String] = []
    
    var alamoError: String = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign mapView delegate
        mapView.delegate = self
        
        //gets user's permission for location
        manager.requestWhenInUseAuthorization()
        
        //load current location (blue dot)
        manager.delegate = self
        manager.activityType = CLActivityType(rawValue: CLActivityType.RawValue(kCLLocationAccuracyBest))!
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.showsScale = true
        
        if manager.location != nil {
            userLocation = (manager.location?.coordinate)!
        }
        else {
            print("Location is Nil")
        }
        
        yelpImage.image = #imageLiteral(resourceName: "Yelp_trademark_RGB.png")
    }
    
    //runs everytime user moves
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        userLocation = locations[0].coordinate
    }
    
    //focuses on current location of user
    func zoomLocation(location: CLLocationCoordinate2D, zoom: Double){
        span = MKCoordinateSpanMake(zoom, zoom)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    func sendAlamoRequest(coord: CLLocationCoordinate2D, clear: Bool, completion: (() -> Void)? = nil){
        yelpAPIurl = "https://api.yelp.com/v3/businesses/search?term=rv-parks&catgories=mobileparks&latitude=\(coord.latitude)&longitude=\(coord.longitude)&radius=16000"
        print(yelpAPIurl)
        sendAlamoRequest(url: yelpAPIurl, clear: clear, completion: completion)
    }
    
    //gets yelp data
    fileprivate func addBusiness(_ park: RVpark) {
        guard RvBusinesses.contains(where: { $0.ID == park.ID }) == false else {
            print("we skipped :\(park.name ?? "unnamed")")
            
            return
        }
        
        RvBusinesses.append(park)
        
        //add annotation to array
        var rvAnnotation = MKPointAnnotation()
        rvAnnotation.title = park.name
        rvAnnotation.coordinate = park.coordinates
        self.RvBusinessesAnno.append(rvAnnotation)
        self.mapView.addAnnotation(rvAnnotation)
    }
    
    func sendAlamoRequest(url: String, clear: Bool, completion: (() -> Void)? = nil) {
        if clear {
            mapView.removeAnnotations(mapView.annotations)
            self.RvBusinessesAnno = []
            RvBusinesses = []
        }
        
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
                    if let value = response.result.value{
                        print("JSON NUM PER CALL: \((JSON(value)["businesses"]).count))")
                        let jsonData = JSON(value)
                        for i in 0..<jsonData["businesses"].arrayValue.count {
//                            usleep(1000)
                            //add businesses to array
                            let jsonPark = jsonData["businesses"].arrayValue[i]
                            let park = RVpark(json: jsonPark, index: i)
                            self.addBusiness(park)
                        }
                        
                        print(RvBusinesses)
                        print("Business Annos: \(self.RvBusinessesAnno.count)")
                        print("Business Annos: \(self.RvBusinessesAnno)")
                        
                        completion?()
                        
                    }
                case .failure(let error):
//                    if error.localizedDescription == "Response status code was unacceptable: 429." {
//                        print("waiting")
//                        usleep(useconds_t(60))
//                        self.sendAlamoRequest(url: url, clear: false)
//                    }
                    
                    print(error.localizedDescription)
                    completion?()
                }
        }
        
        
    }
    
    
    func directions(){
        let sourcePlacemark = MKPlacemark(coordinate: userLocation)
        let destPlacemark = MKPlacemark(coordinate: locationCoords)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {(response, error) in
            guard let response = response else {
                if let error = error {
                    print("Something went wrong: \(error.localizedDescription)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            var i = 0.0
            self.sendAlamoRequest(coord: self.userLocation, clear: false)
            
            var stepsEvery1000Km = [MKRouteStep]()
            for step in route.steps {
                i += step.distance
                if i>=1000{
//                    sleep(UInt32(1))
//                    usleep(useconds_t(30))
                    
//
//                    var rvAnnotation = MKPointAnnotation()
//                    rvAnnotation.title = "Step \(i)"
//                    rvAnnotation.coordinate = step.polyline.coordinate
//                    self.mapView.addAnnotation(rvAnnotation)
                    
                    stepsEvery1000Km.append(step)
                    
                    i = 0
                }
            }
            
            func sendRequest(for steps: [MKRouteStep]) {
                guard let currentStep = steps.first else {
                    return
                }
                
                
                self.sendAlamoRequest(coord: currentStep.polyline.coordinate, clear: false) {
                    let newSteps = Array<MKRouteStep>(steps.dropFirst())
                    sendRequest(for: newSteps)
                }
            }
            
            sendRequest(for: stepsEvery1000Km)
            
            print("businesses collected")
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
        })
        
        print("Businesses: \(RvBusinessesAnno)")
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let overlayGeodesic = overlay as? MKPolyline
        {
            let overLayRenderer = MKPolylineRenderer(polyline: overlayGeodesic)
            overLayRenderer.lineWidth = 5
            overLayRenderer.strokeColor = UIColor(red: 0.25, green: 0.53, blue: 0.77, alpha: 1.0)
            return overLayRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
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
    
    @IBAction func focusButtonPressed(_ sender: Any) {
        zoomLocation(location: userLocation, zoom: 0.5)
    }
    
}

