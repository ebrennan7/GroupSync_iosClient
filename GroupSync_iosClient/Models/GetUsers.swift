//
//  GetUsers.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 14/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
import CoreLocation


class GetUsers{
    
    func getUsersForGroup(group_id: String, completionBlock: @escaping  ([(name: String, longitude: String, latitude: String, updated: DateComponents)]) ->Void) -> Void
    {
        print(KeychainService.loadPassword()!)
        print(group_id)
    
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "55360735-c84c-8e11-d810-efbe9419040f"
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
            } else {
                do{
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    
                    if let dictionary = resultJson{
                        if let nestedDictionary = dictionary["data"] as? [String:Any]{
                            if let locations = nestedDictionary["locations"] as? String
                            {
                                if let users = nestedDictionary["users"] as? String
                                {
                                let returnValue = self.parseLocations(locations: locations, users: users)
                                    completionBlock(returnValue)
                                }
                            }
                            
                        }
                        
                    }
                }
                catch{
                    print("Error -> \(error)")
                }
            }
        })
        
        dataTask.resume()
    }
    
    private func parseLocations(locations: String, users: String) -> [(name: String, longitude: String, latitude: String, updated: DateComponents)]{
        
        var calendar: Calendar = Calendar.current
        var splitNames = users.components(separatedBy: "{")
        var splitLocations = locations.components(separatedBy: "{")
        var stuff:[(name: String, longitude: String, latitude: String, updated: DateComponents)] = []
        var dates = [DateComponents]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss Z"
        let currentDate = Date()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         let unitFlags = Set<Calendar.Component>([.hour, .minute])
        calendar.timeZone = TimeZone(identifier: "GMT")!



        for f in stride(from: 1, to: splitLocations.count, by: 1)
        {
            dates.append(calendar.dateComponents(unitFlags, from: dateFormatter.date(from: splitLocations[f].components(separatedBy: "\"")[13].components(separatedBy: ",")[0])!, to: currentDate))
        }
        
      
       

        
        
        
        for f in stride(from: 1, to: splitLocations.count, by: 1)
        {
            
            if var firstName = splitNames[f].components(separatedBy: ":")[2
                ].components(separatedBy: ",")[0] as? String
            {
                
                let lastName = (splitNames[f].components(separatedBy: ":")[3].components(separatedBy: ",")[0])
                firstName.append(" \(lastName)")


                stuff.append((name: firstName.removeCharacters(from: "\""), longitude: (splitLocations[f].components(separatedBy: ":")[1].components(separatedBy: ",")[0]), latitude: (splitLocations[f].components(separatedBy: ":")[2].components(separatedBy: ",")[0]), updated: dates[f-1]))
            }
  
     

        }
        
  
     
        return stuff
      
        
   
        
    }
}
