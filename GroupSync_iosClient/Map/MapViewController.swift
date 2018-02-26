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
    var currentGroupId: String! //group ID
    var userLocation: CLLocation?
    var locationTuples: [(name: String, longitude: String, latitude: String, updated: DateComponents)]?
  
    var annotation = MKPointAnnotation()

    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager:CLLocationManager!
    
    
    
    @IBAction func mapSettingsButton(_ sender: UIButton) {
        
        
        self.performSegue(withIdentifier: "showSettings", sender: nil)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let groupSettingsController = segue.destination as! GroupSettingsViewController
        groupSettingsController.groupId = currentGroupId
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        print(currentGroupId)
        let getUsers = GetUsers()
        //Below calls the completion block and gets a 'return value' for getUsers//
        (getUsers.getUsersForGroup(group_id: currentGroupId) {(returnValue) in
            self.locationTuples=returnValue
            
            self.populateMap()
            
            
        })
        

        
    }
    func populateMap(){

        DispatchQueue.main.async {
            
  
        
            
            for location in self.locationTuples! {
                let annotation = MKPointAnnotation()
                annotation.title = location.name
                
                if let hours = location.updated.hour {
                    if(hours >= 1){
                        annotation.subtitle = "\(location.updated.hour ?? 0) hour(s) ago"
                    }
                    else{
                        annotation.subtitle = "\(location.updated.minute ?? 0) minute(s) ago"
                    }
                }
                
                
                annotation.coordinate = CLLocationCoordinate2D(latitude: Double(location.latitude)!, longitude: Double(location.longitude)!)
                self.mapView.addAnnotation(annotation)
            }
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
  
        
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
class AnnotationLocation: NSObject, MKAnnotation{
    var user: String?
    var coordinate: CLLocationCoordinate2D
    
    init(user: String, coordinate: CLLocationCoordinate2D){
        self.user = user
        self.coordinate = coordinate
    }
}
