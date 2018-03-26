//
//  RequestModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 06/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//
import Foundation


class RequestModel{
    
    let userInfo = UserDefaults.standard
    
    var requestTuples:[(invite_id: Int, group_id: Int, inviter_id: Int, timeOfInvite: String)] = []
    func getTimeOfRequest(group_id: Int, completion: @escaping (_ time: [String]) -> ())
    {
        var times = [String]()

        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "e32bdaae-a4c0-cadd-d1bc-8d3038deee8b"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_requests")! as URL,
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
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    {
                        if let nestedDictionary = resultJson["data"] as? [String:Any]
                        {
                            if let requestsJson = nestedDictionary["requests"] as? String
                            {
                                let requestsJsonData = requestsJson.data(using: .utf8)
                                
                                if let innerRequest = try JSONSerialization.jsonObject(with: requestsJsonData!, options: []) as? [[String:Any]]
                                {
                                    for requests in innerRequest
                                    {
                                        times.append(self.convertStringToDate(date: requests["created_at"] as! String))
                                        
                                    }
                                    
                                    completion(times)
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                    
                }
                catch{
                    print(error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    
    private func convertStringToDate(date: String) -> String
    {
        if let dateSSS = Formatter.iso8601.date(from: date)
        {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMMM dd,yyyy hh:mma"
            dateFormatterPrint.amSymbol = "AM"
            dateFormatterPrint.pmSymbol = "PM"
            let newDate: String? = dateFormatterPrint.string(from: dateSSS)
            
            return newDate!
            
        }
        
        return date
        
        
    }

        
    
    
    func joinGroup(group_id: Int, completion: @escaping (_ success: Bool) -> ())
    {
        var success: Bool = false
        
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "9fd71a10-915f-e74b-0a80-6843262aef58"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": String(group_id),
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/join_group")! as URL,
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
                        if let confirmation = resultJson["success"] as? Int
                        {
                            
                            if(confirmation==1)
                            {
                                print("Confirmation Sent")
                                success=true
                            }
                        }
                        else{
                            print("Error with confirmation")
                        }
                    }
                    else{
                        print("Error with JSON")
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
    
    
    func deleteRequest(group_id: Int, completion: @escaping (_ success: Bool) -> ())
    {
        
        var success: Bool = false
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "9dfee342-fe30-885e-e354-2e7e0321177b"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": String(group_id),
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/delete_request")! as URL,
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
                    
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                        
                    {
                        print(resultJson)
                        if let info = resultJson["info"] as? String
                        {
                            if(info=="Success")
                            {
                                success=true
                            }
                        }
                    }
                    else{
                        print("Error with JSON")
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
    
    
    
    func getRequests(completionBlock: @escaping ([(invite_id: Int, group_id: Int, inviter_id: Int, timeOfInvite: String)]) -> Void) -> Void {
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "e32bdaae-a4c0-cadd-d1bc-8d3038deee8b"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_requests")! as URL,
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
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    {
                        if let nestedDictionary = resultJson["data"] as? [String:Any]
                        {
                            if let groupsJson = nestedDictionary["requests"] as? String
                            {
                                let groupsJsonData = groupsJson.data(using: .utf8)
                                
                                if let innerGroup = try JSONSerialization.jsonObject(with: groupsJsonData!, options: []) as? [[String:Any]]
                                {
                                    for group in innerGroup
                                    {
                                        self.requestTuples.append((invite_id: group["id"] as! Int ,group_id: group["group_id"] as! Int ,inviter_id: group["inviter_id"] as! Int ,timeOfInvite: group["created_at"] as! String))
                                        
                                    }
                                    
                                    completionBlock(self.requestTuples)
                                    
                                }
                            }
                        }
                        
                        
                        
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

