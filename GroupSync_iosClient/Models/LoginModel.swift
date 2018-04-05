//
//  LoginModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 29/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
class LoginModel{
    
    let userInfo = UserDefaults.standard
    
    func loginPost(email: String, password: String, completion: @escaping (_ token: String, _ success: Bool, _ user_id: Any) -> Void) -> Void
    {
//        var tokenReturn: String?
//        var id_return: Any?
        var success: Bool = false
        var fcmDeviceToken: String = ""
        
        if let deviceToken = userInfo.object(forKey: "fcmToken")
        {
            fcmDeviceToken = deviceToken as! String
        }
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "b5468cec-292a-6c60-d195-6e270909e54b"
        ]
        let parameters = [
            "email": email,
            "password": password,
            "token": fcmDeviceToken
            
            
            ] as [String : Any]
        
        print("Uploaded this token\(fcmDeviceToken)")
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        print(fcmDeviceToken)
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
                                    
                                    success=true
                                    completion(token,success, user_id)

                                
                                    
                                }
                                
                                
                                
                                
                            }
                            else
                            {
                                success = false
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
    private func saveUserInfo(user_info: String)
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
}

