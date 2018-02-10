//
//  CreateGroupModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 30/01/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation


class CreateGroupModel {
    private var name: String
    private var open: String
    private var endTime: Date?
    static var group_id: Int?
    
    
    init(name: String, open: Bool, endTime: Date) {
        self.name=name
        
        if open{
            self.open="true"
        }else{
            self.open="false"
        }
        self.endTime=endTime
    }
    
    
    
    func createGroupPost(completion: @escaping (_ success: Bool) -> ())
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
            "user_id": userInfo.object(forKey: "userID")!,
            "name": name,
            "public": open
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
            return
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/create_group")! as URL,
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
                        
                        if let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                            
                        {
                            
                            DispatchQueue.main.async {
                                
                                
                                print(resultJson)
                                let dictionary = resultJson
                                if let nestedDictionary = dictionary["data"] as? [String: Any]
                                {
                                    print(nestedDictionary)
                                    let group_idString = nestedDictionary["group_id"] as? Int
                                    CreateGroupModel.group_id = group_idString
                                    
                                }
                                
                                
                                
                                
                                self.activeTimesPost()
                                
                                
                                
                                
                            }
                            success=true

                        }
                        
                        //                        else{
                        //                            print("Error with JSON")
                        //                        }
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
    
    
    func activeTimesPost(){
        
        let userInfo = UserDefaults.standard
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "5662b337-4caf-40c5-6127-59ebb5986f5c"
        ]
        let parameters = [
            "start": "2017-02-16 19:14",
            "end": "2017-02-17 21:14",
            "group_id": "1",
            "authToken": KeychainService.loadPassword()!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/add_active_time")! as URL,
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
            } else {
                print(CreateGroupModel.group_id!)
            }
        })
        
        dataTask.resume()
    }
}

