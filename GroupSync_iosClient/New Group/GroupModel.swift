//
//  GroupModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 10/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

class GroupModel{
    
    func getPublicGroups(completionBlock: @escaping ([(group_id: Int, name: String)]) ->Void) -> Void{
        
        var publicTuples:[(group_id: Int, name: String)] = []
        
        let userInfo = UserDefaults.standard
        
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "44b19ed6-9b10-18c4-4e3f-9e13e9a047cc"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData =  try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_public_groups")! as URL,
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
                do{
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                    {
                        if let data = resultJson["data"] as? [String:Any]
                        {
                            if let groups = data["groups"] as? String {
                                let groupsJSONData = groups.data(using: .utf8)
                                
                                if let publicGroups = try JSONSerialization.jsonObject(with: groupsJSONData!, options: []) as? [[String:Any]]
                                {
                                    for group in publicGroups
                                    {
                                        publicTuples.append((group_id: group["id"] as! Int, name: group["name"] as! String))
                                        
                                    }
                                }
                            }
                        }
                        print(publicTuples)
                        completionBlock(publicTuples)
                    }
                }
                catch{
                    print(error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func getPrivateGroups(completionBlock: @escaping ([(group_id: Int, name: String)]) ->Void) -> Void
    {
        var privateTuples:[(group_id: Int, name: String)] = []
        
        let userInfo = UserDefaults.standard
        
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "44b19ed6-9b10-18c4-4e3f-9e13e9a047cc"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData =  try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_groups")! as URL,
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
                do{
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                    {
                        if let data = resultJson["data"] as? [String:Any]
                        {
                            if let groups = data["groups"] as? String {
                                let groupsJSONData = groups.data(using: .utf8)
                                
                                if let privateGroups = try JSONSerialization.jsonObject(with: groupsJSONData!, options: []) as? [[String:Any]]
                                {
                                    
                                    for group in privateGroups
                                    {
                                        if let publicStatus = group["public"] as? Bool{
                                            if(publicStatus==false)
                                            {
                                                privateTuples.append((group_id: group["id"] as! Int, name: group["name"] as! String))
                                            }
                                            else{
                                                print(publicStatus)
                                            }
                                        }
                                    }
                      
                                }
                            }
                        }
                        completionBlock(privateTuples)

                    }
                }
                catch{
                    print(error)
                }
            }
        })
        
        dataTask.resume()
    }
}
