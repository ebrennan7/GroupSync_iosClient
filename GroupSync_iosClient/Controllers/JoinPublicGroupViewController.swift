//
//  JoinPublicGroupViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 10/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class JoinPublicGroupViewController: UIViewController {

    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    
    let groupInfo = GroupInformationModel()
    let requestModel = RequestModel()
    var cellID: String?
    var activeTimes: [(start: String, end: String)] = []
    var groupName: String?
    var numberOfUsers: Int?
    
    @IBAction func joinGroupButtonPressed(_ sender: UIButton) {
        
        joinPublicGroup()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getInfo()
        // Do any additional setup after loading the view.
    }
    
    func joinPublicGroup(){

        requestModel.joinGroup(group_id: Int(cellID!)!, completion: {
            success in
            
            DispatchQueue.main.async {
            
                self.alertHandler(success: success)
                
            }
            
        })
        
        
    
        
    }
    
    
    func getInfo()
    {
        groupInfo.getGroupActiveTimes(group_id: cellID!, completion:{ activeTimesTuple in
            
            self.activeTimes = activeTimesTuple
            
            self.updateTimes()
        })
        
        groupInfo.getGroupName(group_id: cellID!, completion: {group_name in
            self.groupName = group_name
            
            self.updateName()
        })
        
        groupInfo.getNumberOfUsers(group_id: cellID!, completionBlock: { users in
            self.numberOfUsers = users
            
            self.updateNumberOfUsers()
        })

    }
    func updateNumberOfUsers()
    {
        DispatchQueue.main.async {
            self.numberOfPeopleLabel.text = String(self.numberOfUsers!)
        }
    }
    func updateName()
    {
        DispatchQueue.main.async {
            
            self.groupNameLabel.text! = self.groupName!
        }
    }
    func updateTimes()
    {
        DispatchQueue.main.async {
            
            if(self.activeTimes.count==0)
            {
                self.startTimeLabel.text! = "No Start Time"
                self.endTime.text! = "No End Time"
            }
            
            
            
            for time in self.activeTimes
        {
            self.startTimeLabel.text! = time.start
            self.endTime.text! = time.end
        }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func alertHandler(success: Bool)
    {
        if(success)
        {
            createSuccessfulAlert(title: "You have joined the group!", message: "")
        }
        else{
            createUnsuccessfulAlert(title: "Could not join group", message: "")
        }
    }
    
    func createSuccessfulAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        alert.addAction(UIAlertAction(title:"Ok", style: .default, handler: {action in self.performSegue(withIdentifier: "segueToMap", sender: self)}
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapController = segue.destination as! MapViewController
        mapController.currentGroupId = cellID!
    }
    func createUnsuccessfulAlert(title:String, message:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
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
