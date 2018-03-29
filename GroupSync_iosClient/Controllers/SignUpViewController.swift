//
//  SignUpView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpProgress: UIProgressView!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var verifyPasswordLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var verifyPasswordTextField: UITextField!
    
    let signUpModel = SignUpModel()
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if firstNameTextField.text!.isEmpty||lastNameTextField.text!.isEmpty||emailTextField.text!.isEmpty||passwordTextField.text!.isEmpty||verifyPasswordTextField.text!.isEmpty
        {
            createAlert(title: "All fields must be filled in", message: "")
        }
        else if !(passwordTextField.text!==verifyPasswordTextField.text!)
        {
            createAlert(title: "Password fields do not match", message: "")
        }
        else if !((emailTextField.text!).isValidEmail())
            {
                createAlert(title: "Email is not valid", message: "")
            }
        else{
            signUpModel.signUpPostRequest(email: emailTextField.text!.lowercased(), name: firstNameTextField.text!, surname: lastNameTextField.text!, password: passwordTextField.text!, password_re_enter: verifyPasswordTextField.text!, completion: { success in
                
                if(success)
                {
                    self.createLoginAlert(title: "Signup successful", message: "")
                }
                else{
                    self.createAlert(title: "Signup Unsuccessful", message: "")
                }
                
                
            })
        }
    }
  
    func createAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func createLoginAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
//        alert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.default, handler: { (action) in
//            alert.addAction(self.successfulSignUp)
//
        alert.addAction(UIAlertAction(title:"Login", style: .default, handler:  { action in self.performSegue(withIdentifier: "signUpButtonSegue", sender: self) }

            
         ))
        
        self.present(alert, animated: true, completion: nil)

        
    
    }
    
    func successfulSignUp()
    {
        
        if let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as? ViewController
        {
            
            self.present(loginPage ,animated: true,completion: nil)
        }
    }
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLabelShapes()
        
        changeTextViewShapes()
   
        
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.verifyPasswordTextField.delegate = self
//
//        self.addDoneButton()
        
        
        // Do any additional setup after loading the view.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
        
        emailTextField.layer.masksToBounds = true;
        passwordTextField.layer.masksToBounds = true;
        verifyPasswordTextField.layer.masksToBounds = true;
        firstNameTextField.layer.masksToBounds = true;
        lastNameTextField.layer.masksToBounds = true;
        emailTextField.layer.cornerRadius = emailTextField.frame.size.width/24
        verifyPasswordTextField.layer.cornerRadius = verifyPasswordTextField.frame.size.width/24
        firstNameTextField.layer.cornerRadius = firstNameTextField.frame.size.width/24
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.width/24
        lastNameTextField.layer.cornerRadius = lastNameTextField.frame.size.width/24
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func editingFirstNameFinished(_ sender: UITextField) {
        if(firstNameTextField.text != "")
        {
            signUpProgress.progress=0.20
        }
    }
    
    @IBAction func editingLastNameFinished(_ sender: UITextField) {
        
        
        
        if(lastNameTextField.text != "" && signUpProgress.progress == 0.20)
        {
            signUpProgress.progress=0.40;
        }
        
    }
    
    @IBAction func editingEmailFinished(_ sender: UITextField) {
        
        if(emailTextField.text != "" && signUpProgress.progress == 0.40)
        {
            signUpProgress.progress=0.60
        }
        
    }
    
    @IBAction func editingPasswordFinished(_ sender: UITextField) {
        
        if(passwordTextField.text != "" && signUpProgress.progress == 0.60)
        {
            signUpProgress.progress=0.80
        }
        
    }
    
    @IBAction func editingVerifyPasswordFinished(_ sender: UITextField) {
        
        if(verifyPasswordTextField.text == passwordTextField.text && signUpProgress.progress == 0.80)
        {
            signUpProgress.progress=1
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
//Extension to check if a string is a valid email
extension String {
    
    func isValidEmail() -> Bool
    {
        let emailSpec = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailSpec)
        return emailCheck.evaluate(with: self)
    }

}
