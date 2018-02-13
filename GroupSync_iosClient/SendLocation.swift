//
//  SendLocation.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 13/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit



class SendLocation:  NSObject, CLLocationManagerDelegate{
    
    
    var locationManager:CLLocationManager!
    
    
    struct LocationStruct{
        var latitude:CLLocationDegrees?, longitude:CLLocationDegrees?
        
    }
    
    var locationStruct = LocationStruct()
    var userLocation: CLLocation? = nil
    var complete:Bool = false
    
    func sendLocationPost(){
        
        
        let userInfo = UserDefaults.standard
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "edbdfe71-fe2f-7a59-bddb-60a13fc3521e"
        ]
        let parameters = [
            
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!,
            "latitude": userLocation?.coordinate.latitude,
            "longtitude": userLocation?.coordinate.longitude
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/send_location")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    print(error!)
                }
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                print(resultJson)
                
            }
            catch{
                print("Error -> \(error)")
            }
        })
        
        dataTask.resume()
    }
    
    
    func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            DispatchQueue.main.async {
                
                self.locationManager.requestLocation()
            }
            
        }
        
        //        let timeout = DispatchTime.now() + DispatchTimeInterval.seconds(5)
        //
        //        if semaphore.wait(timeout: timeout) == DispatchTimeoutResult.timedOut{
        //         print("Time out")
        //        }
        //
        
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        userLocation = locations[0] as CLLocation
        locationStruct.latitude=userLocation?.coordinate.latitude
        locationStruct.longitude=userLocation?.coordinate.longitude
        
        //
        //        (userLocation?.coordinate.latitude)
        //        print("user longitude = \(userLocation?.coordinate.longitude)")
        //
        //
        //        print(userLocation?.coordinate.latitude)
        
        //        print(semaphore.signal())
        //        semaphore.signal()
        sendLocationPost()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    
    
}
