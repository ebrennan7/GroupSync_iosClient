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

    let groupInfoModel = GroupInformationModel()
    let mapModel = MapViewModel()
    var annotation = MKPointAnnotation()
    var activeStatus: Bool?
    var admin: Bool?
    let getUsers = GetUsers()

    var activeTimes: [(start: String, end: String)] = []


    
    @IBOutlet weak var activeStatusLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    @IBAction func mapSettingsButton(_ sender: UIButton) {
        
        
        self.performSegue(withIdentifier: "showSettings", sender: nil)
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let groupSettingsController = segue.destination as! GroupSettingsViewController
        groupSettingsController.groupId = currentGroupId
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activeStatusLabel.layer.masksToBounds=true
        activeStatusLabel.layer.cornerRadius = view.frame.size.width/24
      
        
        getActiveStatus()

        
        print(currentGroupId)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MapViewController.tappedLabel))
       activeStatusLabel.isUserInteractionEnabled=true
        activeStatusLabel.addGestureRecognizer(tap)
        
        //Below calls the completion block and gets a 'return value' for getUsers//
   
        
        
       
        
    }
    @objc func tappedLabel(sender: UITapGestureRecognizer)
    {
        alertHandler()
    }
    
    func alertHandler()
    {
        
        groupInfoModel.getGroupActiveTimes(group_id: currentGroupId, completion: { activeTimesTuple in
            
            self.activeTimes = activeTimesTuple
            
            self.createAlert(title: "Group Active Times", message: "\nFrom:\n \(activeTimesTuple[0].start)\n\n To:\n \(activeTimesTuple[0].end)")

        })
        
        
    
    }
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func getActiveStatus()
    {
        groupInfoModel.getGroupActiveTimes(group_id: currentGroupId, completion: {activeTimesTuple in
            
            if(activeTimesTuple.count>0)
            {
                
                self.activeStatus=self.mapModel.checkIfActive(start: activeTimesTuple[0].start, end: activeTimesTuple[0].end)
            }
            else{
                self.activeStatus=false
            }
            
            self.updateActivityLabel()
            
            
            
            if self.activeStatus!
            {
                (self.getUsers.getUsersForGroup(group_id: self.currentGroupId) {(returnValue) in
                    self.locationTuples=returnValue
                    
                    self.populateMap()
                    
                    
                })
                
            
                
            }
            
        })
    }
    func updateActivityLabel()
    {
        DispatchQueue.main.async {
            
            if(!self.activeStatus!)
            {
                self.activeStatusLabel.text = "Not Active"
                self.activeStatusLabel.backgroundColor = UIColor.red
            }
        }
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
