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
    
   
    
    @IBAction func createGroupButton(_ sender: UIButton) {
        
        var createGroupModel = CreateGroupModel(name: groupNameTextField.text!, open: publicSwitch.isOn, endTime: activeUntil.date)
        
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
