//
//  SignUpView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class SignUpView: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var verifyPasswordLabel: UILabel!
    
    @IBOutlet weak var firstNameTextView: UITextField!
    
    @IBOutlet weak var lastNameTextView: UITextField!
    
    @IBOutlet weak var emailTextView: UITextField!
    
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBOutlet weak var verifyPasswordTextView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLabelShapes()
        
        changeTextViewShapes()

       
        // Do any additional setup after loading the view.
    }

    func changeLabelShapes()
    {
        emailLabel.layer.masksToBounds = true;
        passwordLabel.layer.masksToBounds = true;
        verifyPasswordLabel.layer.masksToBounds = true;
        firstNameLabel.layer.masksToBounds = true;
        lastNameLabel.layer.masksToBounds = true;
        emailLabel.layer.cornerRadius = emailLabel.frame.size.width/24
        verifyPasswordLabel.layer.cornerRadius = verifyPasswordLabel.frame.size.width/24
        firstNameLabel.layer.cornerRadius = firstNameLabel.frame.size.width/24
        passwordLabel.layer.cornerRadius = passwordLabel.frame.size.width/24
        lastNameLabel.layer.cornerRadius = lastNameLabel.frame.size.width/24
        
    }
    func changeTextViewShapes()
    {
        
        emailTextView.layer.masksToBounds = true;
        passwordTextView.layer.masksToBounds = true;
        verifyPasswordTextView.layer.masksToBounds = true;
        firstNameTextView.layer.masksToBounds = true;
        lastNameTextView.layer.masksToBounds = true;
        emailTextView.layer.cornerRadius = emailTextView.frame.size.width/24
        verifyPasswordTextView.layer.cornerRadius = verifyPasswordTextView.frame.size.width/24
        firstNameTextView.layer.cornerRadius = firstNameTextView.frame.size.width/24
        passwordTextView.layer.cornerRadius = passwordTextView.frame.size.width/24
        lastNameTextView.layer.cornerRadius = lastNameTextView.frame.size.width/24
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
