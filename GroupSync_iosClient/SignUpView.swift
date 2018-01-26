//
//  SignUpView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/11/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation


class SignUpView: UIViewController {
    
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
    
    @IBAction func signUpButton(_ sender: UIButton) {
        if firstNameTextField.text!.isEmpty||lastNameTextField.text!.isEmpty||emailTextField.text!.isEmpty||passwordTextField.text!.isEmpty||verifyPasswordTextField.text!.isEmpty
        {
            createAlert(title: "All fields must be filled in", message: "")
        }
        else if !(passwordTextField.text!==verifyPasswordTextField.text!)
        {
            createAlert(title: "Password fields do not match", message: "")
        }
        else if !(isValidEmail(email: emailTextField.text!))
            {
                createAlert(title: "Email is not valid", message: "")
            }
        else{
            signUpPostRequest()
        }
    }
    func signUpPostRequest()
    {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "14769248-607a-fc94-d01e-86ab7e51e49a"
        ]
        let parameters = [
            "email": emailTextField.text! ,
            "name": firstNameTextField.text!,
            "surname": lastNameTextField.text!,
            "password": passwordTextField.text!,
            "password_re_enter": verifyPasswordTextField.text!
            ] as [String : Any]

        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard let data = postData else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/signup_post")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                DispatchQueue.main.async {
                    
                    print(resultJson)
                    
                    if let dictionary = resultJson as? [String: Any] {
                        if let nestedDictionary = dictionary["data"] as? [String: Any]
                        {
                            //A valid email is only returned if the request was successful
                            
                            if let emailSuccessful = nestedDictionary["user_email"] as? String
                            
                            {
                                self.successfulSignUp()

                            }
                        }
                            else
                            {
                                self.createAlert(title: "Account already exists with that email", message: "")
                            }
                        }
                    }
                
            } catch {
                print("Error -> \(error)")
            }
        })
        
        dataTask.resume()
        
    }
    func createAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func successfulSignUp()
    {
        if let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as? ViewController
        {
            
            self.present(loginView,animated: true,completion: nil)
        }
    }
    
    func isValidEmail(email:String) -> Bool
    {
        let emailSpec = "[A-Z0-0a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailCheck = NSPredicate(format: "SELF MATCHES %@", emailSpec)
        return emailCheck.evaluate(with: email)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeLabelShapes()
        
        changeTextViewShapes()
   
        
        self.addDoneButton()
        
        
        // Do any additional setup after loading the view.
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
        
        self.passwordTextField?.inputAccessoryView = doneToolbar
        self.emailTextField?.inputAccessoryView = doneToolbar
        self.lastNameTextField?.inputAccessoryView = doneToolbar
        self.firstNameTextField?.inputAccessoryView = doneToolbar
        self.verifyPasswordTextField?.inputAccessoryView = doneToolbar
        
        
        
        
    }
    
    @objc func doneButtonAction()
    {
        self.passwordTextField?.resignFirstResponder()
        self.verifyPasswordTextField?.resignFirstResponder()
        self.lastNameTextField?.resignFirstResponder()
        self.firstNameTextField?.resignFirstResponder()
        self.emailTextField?.resignFirstResponder()
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
