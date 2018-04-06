//
//  GetGroupUsers.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 22/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
class GetGroupUsers{
    
    var names = [String]()

    func getUserDetails(group_id: String, completionBlock: @escaping (_ userNames: [String]) ->Void) -> Void{
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
                                    for user in innerUser
                                    {
                                        self.names.append("\(user["name"]!) \(user["surname"]!)")
                                    }
                                    
                                    let returnValue = self.names
                                    completionBlock(returnValue)

                                    
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

}
