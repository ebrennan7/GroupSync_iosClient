//
//  SettingsViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 05/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!

    @IBAction func logOutButtonPressed()
    {
        createAlert(title: "Are you sure you want to log out?", message: "")
    }
    
    @IBAction func `switch`(_ sender: UISwitch) {
//        if(sender.isOn == true)
//        {
//            indicatorLabel.text = "On"
//            indicatorLabel.textColor = UIColor.green
//        }
//        else{
//            indicatorLabel.text = "Off"
//            indicatorLabel.textColor = UIColor.red
//
//        }
    }
    func createAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "unwindToViewController", sender: self)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        

        logOutButton.layer.cornerRadius = logOutButton.frame.size.width/24
//        logOutButton.clipsToBounds = true
    }
    
}
