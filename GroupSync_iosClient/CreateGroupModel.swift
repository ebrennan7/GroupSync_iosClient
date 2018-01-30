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
    
    init(name: String, open: Bool, endTime: Date) {
        self.name=name
        
        if open{
            self.open="yes"
        }else{
            self.open="no"
        }
        self.endTime=endTime
    }
    
    
    func createGroupPost(){
        
        let userInfo = UserDefaults.standard
        
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
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do
                {
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    
                    print(resultJson)
                }
                catch{
                    print("Error -> \(error)")
                }
            }
            
        })
        
        dataTask.resume()
        
    }
}
