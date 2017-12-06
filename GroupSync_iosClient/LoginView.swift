//
//  LoginView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    

 
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.addDoneButton()
        
        changeLabelShapes()
   
        
       

        // Do any additional setup after loading the view.
    }
    func changeLabelShapes()
    {
        emailLabel.layer.masksToBounds = true;
        passwordLabel.layer.masksToBounds = true;
        passwordTextView.layer.masksToBounds = true;
        emailTextField.layer.masksToBounds = true;


        emailLabel.layer.cornerRadius = emailLabel.frame.size.width/24
        passwordLabel.layer.cornerRadius = passwordLabel.frame.size.width/24
        emailTextField.layer.cornerRadius = emailTextField.frame.size.width/24
        passwordTextView.layer.cornerRadius = passwordTextView.frame.size.width/24

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDoneButton()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginView.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.passwordTextView?.inputAccessoryView = doneToolbar
        self.emailTextField?.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.passwordTextView?.resignFirstResponder()
        self.emailTextField?.resignFirstResponder()
    }

}
