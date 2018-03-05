//
//  GroupSettingsViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 26/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class GroupSettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var settingsView: UIView!
    var userNames = [String]()
    var groupId: String!
    let groupSettingsModel = GroupSettingsModel()
    var success: Bool?
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func deleteGroup(_ sender: UIButton) {
        
        groupSettingsModel.deleteGroupPost(group_id: groupId, completion: { success in
            
            
            DispatchQueue.main.async {
                
                
                self.alertHandler(success: success)            }
            
            
            
            
        })
        
        
    }
    
    @IBAction func emailToAdd(_ sender: UITextField) {
        
    }
    func alertHandler(success: Bool)
    {
        if(success)
        {
            createSuccessfulAlert(title: "Group Deletion Successul", message: "")
        }
        else{
            createUnsuccessfulAlert(title: "Group Deletion Failed", message: "")
        }
    }
    
    
    func createSuccessfulAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        alert.addAction(UIAlertAction(title:"Ok", style: .default, handler: {action in self.performSegue(withIdentifier: "backToGroups", sender: self)}
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func createUnsuccessfulAlert(title:String, message:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMembers_cell", for: indexPath) as! UsersCollectionViewCell
        
        cell.userName.text = userNames[indexPath.row]
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate=self
        let getGroupUsers = GetGroupUsers()
        
        (getGroupUsers.getUserDetails(group_id: groupId)
            
        {(returnValue)
            in self.userNames = (returnValue)
        })
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.usersCollectionView.delegate=self
        self.usersCollectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if((emailTextField.text!).isValidEmail())
        {
            groupSettingsModel.addUsersPost(group_id: groupId, email: emailTextField.text!, completion:  {success in
                
                if(success)
                {
                    self.updateDisplay()
                }
                else{
                    print("FAILURE")
                }
                
                
            })
        }
        return true
    }
    
    func updateDisplay()
    {
        DispatchQueue.main.async {
       
        self.view.setNeedsDisplay()
        }
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
