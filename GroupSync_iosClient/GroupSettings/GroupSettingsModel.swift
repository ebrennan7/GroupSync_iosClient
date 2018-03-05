//
//  GroupSettingsModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 26/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

class GroupSettingsModel{
    
    
    func addUsersPost(email: String)
    {
        print("WORKED")
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
                                    print("DIDNT WORK")
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
