//
//  CreateGroupViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 30/01/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var activeUntil: UIDatePicker!
    @IBOutlet weak var activeFrom: UIDatePicker!
    
    
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        if(groupNameTextField.text==""){
            createUnsuccessfulAlert(title: "Please enter a group name", message: "")
        }
        else{
            createGroupAction()
        }

     }
    
    func createGroupAction(){
        let createGroupModel = CreateGroupModel(name: groupNameTextField.text!, open: publicSwitch.isOn, startTime: activeFrom.date, endTime: activeUntil.date)
        
        
        
        createGroupModel.createGroupPost(completion: { success in
            if(success)
            {
                DispatchQueue.main.async {
                    
                    self.alertHandler(success: success)
                }
            }
            else{
                DispatchQueue.main.async {
                    
                    self.alertHandler(success: success)            }
            }
            
            
            
        })
    }
    
    
    func alertHandler(success: Bool)
    {
        if(success)
        {
            createSuccessfulAlert(title: "Group Creation Successul", message: "")
        }
        else{
            createUnsuccessfulAlert(title: "Group Creation Failed", message: "")
        }
    }
    
    
    func createSuccessfulAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        alert.addAction(UIAlertAction(title:"Ok", style: .default, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func createUnsuccessfulAlert(title:String, message:String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
