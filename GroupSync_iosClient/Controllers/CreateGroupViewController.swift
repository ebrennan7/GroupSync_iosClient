//
//  CreateGroupViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 30/01/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var activeUntil: UIDatePicker!
    @IBOutlet weak var activeFrom: UIDatePicker!
    
    
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        if(groupNameTextField.text==""){
            self.createAlert(title: "Please enter a group name", message: "")

        }
        else if(activeFrom.date.description != activeUntil.date.description && activeFrom.date<activeUntil.date)
        {
            createGroupAction()

        }
        else{

                    self.createAlert(title: "Please select a valid time interval", message: "")
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
            self.createAlert(title: "Group Creation Failed", message: "")

        }
    }
    
    
    func createSuccessfulAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        
        alert.addAction(UIAlertAction(title:"Ok", style: .default, handler:  { action in self.performSegue(withIdentifier: "backToHome", sender: self) }
            
            
        ))
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    

    
    @IBOutlet var groupNameLabel: UILabel!
    @IBOutlet var makePublicGroupLabel: UILabel!
    @IBOutlet var groupActiveFromLabel: UILabel!
    @IBOutlet var groupActiveUntilLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameTextField.roundTextFieldEdges()
        groupNameLabel.roundLabelEdges()
        makePublicGroupLabel.roundLabelEdges()
        groupActiveFromLabel.roundLabelEdges()
        groupActiveUntilLabel.roundLabelEdges()
        self.groupNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Keyboard should close when tapping outside of it
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //Keyboard closes when pressing done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupNameTextField.resignFirstResponder()
        return true
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
