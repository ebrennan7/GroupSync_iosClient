//
//  GroupInformationModel.swift
//  
//
//  Created by Ember Brennan on 10/03/2018.
//

import UIKit

class GroupInformationModel{
    
    let userInfo = UserDefaults.standard
    
    
    func getGroupName(group_id: String, completion: @escaping (_ group_name: String) -> Void) -> Void{
        
        var group_name: String?
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "f76a14d7-1e18-867c-72e4-e705a4472d52"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": group_id
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_group")! as URL,
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
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject] {
                        if let dataJson = resultJson["data"] as? [String:Any]{
                            if let groupInfo = dataJson["group"] as? String {
                                
                                let groupInfoData = groupInfo.data(using: .utf8)
                                
                                if let names = try JSONSerialization.jsonObject(with: groupInfoData!, options: []) as? [String:Any]
                                {
                                    
                                    
                                    group_name = names["name"] as? String
                                    
                                    
                                    
                                    
                                    
                                }
                                completion(group_name!)
                                
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
    
    
    
    func getNumberOfUsers(group_id: String, completionBlock: @escaping (_ users: Int) ->Void) -> Void{
        
        var users: Int = 0
        
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
                                for _ in innerUser
                                {
                                    users+=1
                                }
                                
                                completionBlock(users)
                                //                                    for name in innerUserData{
                                //                                        names.append(innerUserData["name"])
                                //                                    }
                                
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
   
    func getGroupActiveTimes(group_id: String, completion: @escaping ([(start: String, end: String)]) -> Void) -> Void{
        
        var activeTimeTuples: [(start: String, end: String)] = []
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "cc2a0c93-3204-7724-882f-9ad11562c483"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "group_id": group_id
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_active_times")! as URL,
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
                        print(resultJson)
                        
                        
                        if let dataJson = resultJson["data"] as? [String:Any]
                        {
                            print(dataJson)
                            if let activeTimesArray = dataJson["active_times"] as? String
                            {
                                let activeTimesData = activeTimesArray.data(using: .utf8)
                                
                                if let times = try JSONSerialization.jsonObject(with: activeTimesData!, options: []) as? [[String:Any]]
                                {
                                    
                                    
                                    for time in times
                                    {
                                        
                                        activeTimeTuples.append((start: self.convertStringToDate(date: time["start"]! as! String), end: self.convertStringToDate(date: time["end"]! as! String)))
                                        
                                        
                                    }
                                    
                                    
                                }
                                completion(activeTimeTuples)
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
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        if #available(iOS 11.0, *) {
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            // Fallback on earlier versions
        }
        return formatter
    }()
}
