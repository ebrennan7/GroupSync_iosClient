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
    var annotation = MKPointAnnotation()
    var userLocation: CLLocation?
    let location = SendLocation()


    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    
    @IBAction func mapSettingsButton(_ sender: UIButton) {
    

        
            self.location.sendLocationPost()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        print(data)
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        determineCurrentLocation()
     
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


        print("user latitude = \(userLocation?.coordinate.latitude)")
        print("user longitude = \(userLocation?.coordinate.longitude)")
        annotation.coordinate = CLLocationCoordinate2D(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        annotation.title = "You"
        mapView.addAnnotation(annotation)


    }

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
