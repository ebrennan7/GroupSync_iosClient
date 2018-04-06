//
//  SignUpModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 29/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

class SignUpModel{
    
    
    func signUpPostRequest(email:String, name: String, surname: String, password: String, password_re_enter: String, completion: @escaping (_ success: Bool) -> Void) -> Void
    {
        
        let userInfo = UserDefaults.standard
        
        var fcmDeviceToken: String = ""
        
        var success: Bool = false
        if let deviceToken = userInfo.object(forKey: "fcmToken")
        {
            fcmDeviceToken = deviceToken as! String
        }
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "14769248-607a-fc94-d01e-86ab7e51e49a"
        ]
        let parameters = [
            "email":  email,
            "name": name,
            "surname": surname,
            "password": password,
            "password_re_enter": password_re_enter,
            "token": fcmDeviceToken
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
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
                print(error!)
            }
            do {
                let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                
                DispatchQueue.main.async {
                    
                    
                    if let dictionary = resultJson {
                        if let nestedDictionary = dictionary["data"] as? [String: Any]
                        {
                            //A valid email is only returned if the request was successful
                            
                            if (nestedDictionary["user_email"] as? String) != nil
                                
                            {
                                success=true
                                
                            }
                        }
                        else
                        {
                           success=false
                        }
                        
                        completion(success)
                    }
                }
                
            } catch {
                print("Error -> \(error)")
            }
        })
        
        dataTask.resume()
        
    }
}
