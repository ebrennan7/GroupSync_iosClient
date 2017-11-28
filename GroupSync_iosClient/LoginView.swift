//
//  LoginView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addDoneButton()

        // Do any additional setup after loading the view.
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
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
