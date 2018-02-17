//
//  MapViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 10/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    var group_id: String?
    var data: String! //group ID
    var userLocation: CLLocation?
    var locationTuples: [(name: String, longitude: String, latitude: String, updated: String)]?
  
    var annotation = MKPointAnnotation()

    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    let location = SendLocation()
    
    
    @IBAction func mapSettingsButton(_ sender: UIButton) {
        
        
        
        self.location.determineCurrentLocation()
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        print(data)
        let getUsers = GetUsers()
        //Below calls the completion block and gets a 'return value' for getUsers//
        (getUsers.getUsersForGroup(group_id: data) {(returnValue) in
            self.locationTuples=returnValue
            
            self.populateMap()
            
            
        })
        

        
    }
    func populateMap(){

        DispatchQueue.main.async {
            


//            var f=0
//            while f<(self.locationTuples?.count)!
//            {
//
//
//                //            print(self.locationTuples)
//
//                print(self.locationTuples)
//                self.annotation.coordinate = CLLocationCoordinate2D(latitude: Double(self.locationTuples![f].latitude)!, longitude: Double(self.locationTuples![f].longitude)!)
//                self.annotation.title = "User \(f)"
//                self.mapView.addAnnotation(self.annotation)
//            f=f+1
//
            
//            }
            
            
        
            
            for location in self.locationTuples! {
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                annotation.subtitle = location.updated
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        //        determineCurrentLocation()
        
    }
    //
    //    func determineCurrentLocation(){
    //        locationManager = CLLocationManager()
    //        locationManager.delegate = self
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestAlwaysAuthorization()
    //
    //        if CLLocationManager.locationServicesEnabled(){
    //            locationManager.startUpdatingLocation()
    //        }
    //    }
    //
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
    //        userLocation = locations[0] as CLLocation
    //
    //
    //        print("user latitude = \(userLocation?.coordinate.latitude)")
    //        print("user longitude = \(userLocation?.coordinate.longitude)")
    //        annotation.coordinate = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
    //        annotation.title = "You"
    //        mapView.addAnnotation(annotation)
    //
    //
    //    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
class AnnotationLocation: NSObject, MKAnnotation{
    var user: String?
    var coordinate: CLLocationCoordinate2D
    
    init(user: String, coordinate: CLLocationCoordinate2D){
        self.user = user
        self.coordinate = coordinate
    }
}
