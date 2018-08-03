//
//  GoogleMapsExtension.swift
//  RvStops
//
//  Created by Anna Grace on 8/1/18.
//  Copyright © 2018 Anna Grace. All rights reserved.
//

import Foundation
import GooglePlaces

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.mapView.removeOverlays(mapView.overlays)
        locationAddress = place.formattedAddress!
        locationCoords = place.coordinate
        startLocationTextField.text = locationAddress
        
        yelpAPIurl = "https://api.yelp.com/v3/businesses/search?term=rv-parks&latitude=\(locationCoords.latitude)&longitude=\(locationCoords.longitude)"
        
        sendAlamoRequest(url: yelpAPIurl, clear: true)
        
        zoomLocation(location: locationCoords, zoom: 1)
        
        directions()
        
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
