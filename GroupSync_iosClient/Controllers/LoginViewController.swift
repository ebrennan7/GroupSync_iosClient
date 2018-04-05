//
//  LoginView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Security



class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let userInfo = UserDefaults.standard
    let loginModel = LoginModel()
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    @IBAction func logInButton(_ sender: UIButton) {
        if emailTextField
            .text!.isEmpty||passwordTextField.text!.isEmpty{
            createAlert(title: "You must fill in Email and Password fields", message: "")
        }
        else
        {
            self.loginModel.loginPost(email: emailTextField.text!.lowercased(), password: passwordTextField.text!, completion: {
                token,success,user_id  in
                
                if(success)
                {
                    self.successfulLogin(token: token, user_id: user_id as! Int)
                }
                else{
                    self.createAlert(title: "Couldn't log in", message: "")
                }
                
                
            })
        }
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func successfulLogin(token: String, user_id: Int)
    {
        
        let token = token as NSString
        KeychainService.savePassword(token: token)
        
        //Not ideal to have password saved in userdefaults for security reasons but it is to get around a restricting feature of the web application
        userInfo.set(passwordTextField.text!, forKey: "password")
        //Below keeps user logged in if they have been authorised//
        userInfo.set("loggedIn", forKey: "userSignedIn")
        userInfo.set(user_id, forKey: "userID")
    
        userInfo.synchronize()
        
        
        if let homeView = self.storyboard?.instantiateViewController(withIdentifier: "homeView") as? HomeViewController {
            print("NOW")
            
            
            let navController = UINavigationController(rootViewController: homeView)
            
            self.present(navController, animated: true, completion: nil)
            //                                    self.navigationController?.present(homeView, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        
        changeLabelShapes()

                self.passwordTextField.delegate=self
        self.emailTextField.delegate=self

        
        
    }
    
   
    
    
    
    func createAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func changeLabelShapes()
    {
        emailLabel.roundLabelEdges()
        passwordLabel.roundLabelEdges()
        passwordTextField.roundTextFieldEdges()
        emailTextField.roundTextFieldEdges()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension UILabel{
    func roundLabelEdges()
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width/24
    }
}
extension UITextField{
    func roundTextFieldEdges(){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width/24
    }
}

