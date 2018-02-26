//
//  GetGroupUsers.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 22/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
class GetGroupUsers{
    
    
    func getUserDetails(){
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "a362019e-d006-b752-5414-c60d5be0abf8"
        ]
        let parameters = [
            "authToken": "8e483bf5-3281-4321-b814-edc7115b9097",
            "group_id": "85"
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
                print(error)
            }
            do{
                
                if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                    
                    let dictionary = resultJson
                    if let nestedDictionary = dictionary["data"] as? [String:Any]
                    {
                        
                        if var usersJSON = nestedDictionary["users"] as? String
                        {
                        
//                            usersJSON = usersJSON.trimmingCharacters(in: ["[", "]"])
//
//                            print(usersJSON)
                            
                            
                            
                            let usersJSONData = usersJSON.data(using: .utf8)
                            
                            
                            
                                if let innerUserData = try JSONSerialization.jsonObject(with: usersJSONData!, options: []) as? [[String:Any]]
                                {
                                    var names = [String]()
                                    for anUser in innerUserData
                                    {
                                        names.append(anUser["name"]! as! String)
                                    }
//                                    for name in innerUserData{
//                                        names.append(innerUserData["name"])
//                                    }
                                    print(names)
                                }
                                else{
                                    print("inner data didnt work")
                                }
                    
                        }
                        else{
                            print("FAIL AT TOP LEVEL")
                        }
                        
                    }
                    else{
                        print("Can't do array thing")
                    }
                    
                    
                    
                }
                
            }
            catch{
                print("Error 33")
            }
        })
        
        dataTask.resume()
    }
}