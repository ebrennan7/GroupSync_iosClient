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
    
    @IBOutlet weak var indicatorLabel: UILabel!
    
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
    override func viewDidLoad() {
        

        logOutButton.layer.cornerRadius = logOutButton.frame.size.width/10
//        logOutButton.clipsToBounds = true
    }
    
}
