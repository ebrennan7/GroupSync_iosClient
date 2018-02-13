//
//  SendLocation.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 13/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
import CoreLocation



class SendLocation:  NSObject, CLLocationManagerDelegate{
   
    
    var locationManager:CLLocationManager!
    

    struct LocationStruct{
        var latitude:CLLocationDegrees?, longitude:CLLocationDegrees?
    }
    
    var locationStruct = LocationStruct()
    var userLocation: CLLocation? = nil


    func sendLocationPost(){
        determineCurrentLocation()
        print(userLocation) // This is nil
        print(locationStruct.latitude) // This is nil
        print(locationStruct.longitude) // This is nil

    }
    
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        userLocation = locations[0] as CLLocation
        
        
//
//        (userLocation?.coordinate.latitude)
        print("user longitude = \(userLocation?.coordinate.longitude)")


        print(userLocation?.coordinate.latitude)
        locationStruct.latitude=userLocation?.coordinate.latitude
        locationStruct.longitude=userLocation?.coordinate.longitude
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    
}
