//
//  MapViewModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 13/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation

extension Date {
    func isBetween(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
}


class MapViewModel{
    var activeStatus: Bool?
    
    func checkIfActive(start: String, end: String) -> Bool
    {
       
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy hh:mma"
        
        let dateStart = dateFormatterPrint.date(from: start)
        let dateEnd = dateFormatterPrint.date(from: end)

        if(Date().isBetween(date: dateStart!, andDate: dateEnd!))
        {
            return true
        }
        return false
    }
    
    func getUserDetails(group_id: String, completionBlock: @escaping (_ admin: Bool) ->Void) -> Void{
        
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
                print(error)
            }
            do{
                
                if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]{
                    
                    let dictionary = resultJson
                    if let nestedDictionary = dictionary["data"] as? [String:Any]
                    {
                        
                        if let usersJSON = nestedDictionary["users"] as? String
                        {
                            
                            //                            usersJSON = usersJSON.trimmingCharacters(in: ["[", "]"])
                            //
                            //                            print(usersJSON)
                            
                            
                            
                            let usersJSONData = usersJSON.data(using: .utf8)
                            
                            
                            
                            if let innerUser = try JSONSerialization.jsonObject(with: usersJSONData!, options: []) as? [[String:Any]]
                            {
                              
                                print(innerUser[0]["id"])

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
    
    func checkIfAdmin(){
        
    }
}
