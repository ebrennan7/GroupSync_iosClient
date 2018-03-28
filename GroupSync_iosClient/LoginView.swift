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



class LoginView: UIViewController, UITextFieldDelegate {
    
    let userInfo = UserDefaults.standard

    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    func isConnectedToInternet() -> Bool
    {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    
    
    @IBAction func logInButton(_ sender: UIButton) {
        if emailTextField
            .text!.isEmpty||passwordTextField.text!.isEmpty{
            createAlert(title: "You must fill in Email and Password fields", message: "")
        }
        else if !(isConnectedToInternet())
        {
            createAlert(title: "You don't have an active internet connection", message: "")
        }
        else
        {
            self.loginPost()
        }
        
    }
    
    func loginPost()
    {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "b5468cec-292a-6c60-d195-6e270909e54b"
        ]
        let parameters = [
            "email": emailTextField.text!.lowercased(),
            "password": passwordTextField.text!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/login_post")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                DispatchQueue.main.async {
                    print(error!)
                    
                }
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                DispatchQueue.main.async {
                    
                    
                    if let dictionary = resultJson {
                        if let nestedDictionary = dictionary["data"] as? [String: Any] {
                            
                            if let token  = nestedDictionary["authToken"] as? String
                            {
                                
                                if let user_id = nestedDictionary["user_id"]
                                {
                                    print(user_id)
                                    print(token)
                                    
                                    self.successfulLogin(token: token, user_id: user_id as! Int)
                                    
                                }
                                
                                
                                //For testing //
                                
                                
                                
                            }
                            else
                            {
                                self.createAlert(title: "Email and password do not match an existing account", message: "")
                            }
                            
                            if let user_info = nestedDictionary["user"]{
                                self.saveUserInfo(user_info: (user_info as! String))
                            }
                        }
                    }
                }
            } catch {
                print("Error -> \(error)")
            }
        })
        
        dataTask.resume()
        
    }
    func saveUserInfo(user_info: String)
    {
        let userInfo = UserDefaults.standard
        var names = user_info.components(separatedBy: ",")
        var content = (names[4]).components(separatedBy: ":")
        
        let firstName = content[1]
        content = (names[5].components(separatedBy: ":"))
        let secondName = content[1]
        
        content = names[3].components(separatedBy: ":")
        let email = content[1]
        
        print(names[7])
        print(names[6])

        content = names[7].components(separatedBy: ":")
        let contentType = content[1]
        
        content = names[6].components(separatedBy: ":")
        let fileName = content[1]
        
        
        userInfo.set(firstName, forKey: "firstName")
        userInfo.set(secondName, forKey: "secondName")
        userInfo.set(email, forKey: "email")
        userInfo.set(fileName, forKey: "fileName")
        userInfo.set(contentType, forKey: "contentType")
        
        userInfo.synchronize()
        
        
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
        
        
        if let homeView = self.storyboard?.instantiateViewController(withIdentifier: "homeView") as? HomeView {
            print("NOW")
            
            
            let navController = UINavigationController(rootViewController: homeView)
            
            self.present(navController, animated: true, completion: nil)
            //                                    self.navigationController?.present(homeView, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //        if !AWSSignInManager.sharedInstance().isLoggedIn
        //        {
        //            presentAuthUIViewController()
        //        }
        
//        self.addDoneButton()
        
        changeLabelShapes()
        
        
        self.passwordTextField.delegate=self
        self.emailTextField.delegate=self
    
        
        
        // Do any additional setup after loading the view.
    }
    
    //
    //    func presentAuthUIViewController()
    //    {
    //        let config = AWSAuthUIConfiguration()
    //        config.enableUserPoolsUI = true
    //        config.backgroundColor = UIColor.blue
    //        config.font = UIFont (name: "Helvetica Neue", size: 20)
    //        config.isBackgroundColorFullScreen = true
    //        config.canCancel = true
    //
    //        AWSAuthUIViewController.presentViewController(
    //            with: self.navigationController!,
    //            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
    //                if error == nil {
    //                    // SignIn succeeded.
    //                } else {
    //                    // end user faced error while loggin in, take any required action here.
    //                }
    //        })
    //    }
    
    
    
    func createAlert(title:String, message: String)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func changeLabelShapes()
    {
        emailLabel.layer.masksToBounds = true;
        passwordLabel.layer.masksToBounds = true;
        passwordTextField.layer.masksToBounds = true;
        emailTextField.layer.masksToBounds = true;
        
        
        emailLabel.layer.cornerRadius = emailLabel.frame.size.width/24
        passwordLabel.layer.cornerRadius = passwordLabel.frame.size.width/24
        emailTextField.layer.cornerRadius = emailTextField.frame.size.width/24
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.width/24
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    func addDoneButton()
//    {
//        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
//        doneToolbar.barStyle       = UIBarStyle.default
//        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginView.doneButtonAction))
//
//        var items = [UIBarButtonItem]()
//        items.append(flexSpace)
//        items.append(done)
//
//        doneToolbar.items = items
//        doneToolbar.sizeToFit()
//
//        self.passwordTextField?.inputAccessoryView = doneToolbar
//        self.emailTextField?.inputAccessoryView = doneToolbar
//    }
//
//    @objc func doneButtonAction()
//    {
//        self.passwordTextField?.resignFirstResponder()
//        self.emailTextField?.resignFirstResponder()
//    }
    
}

