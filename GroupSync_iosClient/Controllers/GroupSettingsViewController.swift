//
//  GroupSettingsViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 26/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class GroupSettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet var settingsView: UIView!
    var userNames = [String]()
    var groupId: String!
    let groupSettingsModel = GroupSettingsModel()
    var success: Bool?
    var admin: Bool?
    
    @IBOutlet weak var redButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBAction func deleteGroup(_ sender: UIButton) {
        
        if(admin!)
        {
            
            groupSettingsModel.deleteGroupPost(group_id: groupId, completion: { success in
                
                
                DispatchQueue.main.async {
                    
                    
                    self.alertHandler(success: success)
                    
                }
                
                
                
                
            })
        }
        else{
            groupSettingsModel.leaveGroupPost(group_id: groupId, completion: {success in
                
                self.alertLeaveHandler(success: success)
            })
        }
        
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
            self.createAlert(title: "Group Deletion Failed", message: "")
        }
    }
    
    
    func createSuccessfulAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        
        
        alert.addAction(UIAlertAction(title:"Ok", style: .default, handler: {action in self.navigationController?.popToRootViewController(animated: true)}
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    

    func alertLeaveHandler(success: Bool)
    {
        if(success)
        {
            createSuccessfulAlert(title: "You have the left the group", message: "")
        }
        else{
            self.createAlert(title: "Leave group failed", message: "")
        }
    }
    
    
    
    
    func alertAddHandler(success: Bool)
    {
        if(success)
        {
            self.createAlert(title: "User Invite Successful", message: "")
        }
        else{
            self.createAlert(title: "User Invite Failed", message: "")
        }
    }
    
    func checkIfAdmin()
    {
        
        groupSettingsModel.checkAdmin(group_id: groupId, completionBlock: {admin in
            
            self.admin=admin
            self.updateRedButton()
            
        })
    }
    
    func updateRedButton()
    {
        DispatchQueue.main.async {
            
            if(!self.admin!){
                self.redButton.titleLabel?.text! = "Leave Group?"
            }
            else if(self.admin!){
                self.redButton.titleLabel?.text! = "Delete Group?"
            }
            else{
                self.redButton.titleLabel?.text! = "Leave Group?"
            }
        }
    }

    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMembers_cell", for: indexPath) as! UsersCollectionViewCell
        
        cell.userName.text = userNames[indexPath.row]
        loading.hidesWhenStopped=true
        loading.stopAnimating()
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        emailTextField.delegate=self
        let getGroupUsers = GetGroupUsers()
        
        (getGroupUsers.getUserDetails(group_id: groupId)
            
        {returnValue in self.userNames = (returnValue)
        
            DispatchQueue.main.async {
                
                self.usersCollectionView.delegate=self
                self.usersCollectionView.dataSource = self
            }
        })
        
        checkIfAdmin()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
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
                    self.alertAddHandler(success: success)
                    
                    self.resetEmailTextField()
                }
                else{
                    self.alertAddHandler(success: success)
                }
                
                
            })
        }
        return true
    }
    
    func resetEmailTextField()
    {
        DispatchQueue.main.async {
            self.emailTextField.text! = ""
        }
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
