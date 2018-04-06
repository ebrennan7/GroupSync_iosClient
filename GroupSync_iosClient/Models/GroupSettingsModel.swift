//
//  GroupSettingsModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 26/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

class GroupSettingsModel{
    
    func checkAdmin(group_id: String, completionBlock: @escaping (_ admin: Bool) ->Void) -> Void{
        
        let userInfo = UserDefaults.standard
        var admin: Bool = false
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "a362019e-d006-b752-5414-c60d5be0abf8"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": group_id
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_groups_users")! as URL,
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
            do{
                
                if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                    
                    let dictionary = resultJson
                    if let nestedDictionary = dictionary["data"] as? [String:Any]
                    {
                        
                        if let usersJSON = nestedDictionary["users"] as? String
                        {
         
                            
                            let usersJSONData = usersJSON.data(using: .utf8)
                            
                            
                            
                            if let innerUser = try JSONSerialization.jsonObject(with: usersJSONData!, options: []) as? [[String:Any]]
                            {
                         
                                
                                if(innerUser[0]["id"] as? Int == userInfo.object(forKey: "userID") as? Int)
                                {
                                    admin=true
                                }
                                
                                
                                completionBlock(admin)
                            }
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }
                
            }
            catch{
                print("Error")
            }
        })
        
        dataTask.resume()
    }
    
    func addUsersPost(group_id: String, email: String, completion: @escaping (_ success: Bool) -> ())
    {
        
        var success: Bool = false
        let userInfo = UserDefaults.standard
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "74678695-bbf6-0dd3-540f-e40c6f5dcf56"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!,
            "group_id": group_id,
            "email": email.lowercased()
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/add_user_to_group")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do {
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                    {
                        print(resultJson)
                        if let nestedDictionary = resultJson["success"] as? Int
                        {
                            
                            if(nestedDictionary==1)
                            {
                                
                                success=true
                            }
                            
                        }
                        else{
                            success=false
                        }
                        
                        
                    }
                    
                    
                }
                catch{
                    print(error)
                }
            }
            completion(success)
        })
        
        dataTask.resume()
    }
    
    func deleteGroupPost(group_id: String, completion: @escaping (_ success: Bool) -> ())
    {
        var success: Bool = false
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "ab805411-d17a-dce6-a69a-50f35a365c16"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": group_id
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/delete_group")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        DispatchQueue.main.async {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    do
                    {
                        
                        if let resultJson = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String:AnyObject]
                            
                        {
                            
                            
                            
                            
                            let dictionary = resultJson
                            if let nestedDictionary = dictionary["success"] as? Int
                            {
                                
                                if(nestedDictionary==1)
                                {
                                    
                                    success=true
                                }
                                
                            }
                            else{
                                success=false
                            }
                            
                            
                            
                            
                            
                            
                            
                            
                            
                            
                        }
                            
                        else{
                            print("Error with JSON")
                        }
                    }
                    catch{
                        print("Error -> \(error)")
                    }
                }
                completion(success)
            })
            dataTask.resume()
            
        }
        
        
    }
    
    func leaveGroupPost(group_id: String, completion: @escaping (_ success: Bool) -> ())
    {
        let userInfo = UserDefaults.standard
        var success: Bool = false
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "ab805411-d17a-dce6-a69a-50f35a365c16"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": group_id,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/leave_group")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        DispatchQueue.main.async {
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    do
                    {
                        
                        if let resultJson = try JSONSerialization.jsonObject(with: data!, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String:AnyObject]
                            
                        {
                            let dictionary = resultJson
                            if let nestedDictionary = dictionary["success"] as? Int
                            {
                                
                                if(nestedDictionary==1)
                                {
                                    
                                    success=true
                                }
                                
                            }
                            else{
                                success=false
                            }
                        }
                            
                        else{
                            print("Error with JSON")
                        }
                    }
                    catch{
                        print("Error -> \(error)")
                    }
                }
                completion(success)
            })
            dataTask.resume()
            
        }
    }
}
