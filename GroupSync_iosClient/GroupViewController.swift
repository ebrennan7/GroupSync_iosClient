//
//  GroupsView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation

class GroupViewController: UIViewController, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! GroupCollectionViewCell

        return cell
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }
    
    
    
    
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    var result = [GroupObject]()
    

 

    
    
    func getGroups()
    {
        let userInfo = UserDefaults.standard
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "54b3a185-141b-a74b-dcf1-5073dcd82fc0"
        ]
        let parameters = [
            "authToken": KeychainService.loadPassword()!,
            "user_id": userInfo.object(forKey: "userID")!
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else {
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
                
                do {
                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
                    
                    DispatchQueue.main.async {
                        
                        if let dictionary = resultJson {
                            if let nestedDictionary = dictionary["data"] as? [String: Any]{
                                if let groups = nestedDictionary["groups"] as? String{
                                    
                                    
                                    
                                    
                                    
                                    
                                    self.result = self.getObjects(groupId: self.getGroupIds(groups: groups), groupName: self.getGroupNames(groups: groups), groupImage: #imageLiteral(resourceName: "Groups"))
                                    
                                    
                                    print(self.result.count)
                                    
                                    
                                }
                            }
                        }
                    }
                }
                catch {
                    print("Error -> \(error)")
                }
            }
        })
        
        dataTask.resume()
    }
    func getObjects(groupId: [String], groupName: [String], groupImage: UIImage?) -> [GroupObject]
    {
        var groupList = [GroupObject]()
        
        for f in 0..<groupId.count{
            groupList.append(GroupObject.init(groupId: groupId[f], groupName: groupName[f], groupImage: #imageLiteral(resourceName: "Groups")))
        }
        
        return groupList
    }
    
    func getGroupIds(groups: String) ->  [String]
    {
        
        let groups=groups
        
        var groupIds = groups.components(separatedBy: ",")
        
        
        var groupIdList = [String]()
        let loopBoundary = groupIds.count/2 + 14
        
        for f in stride(from: 0, to: loopBoundary, by: 12)
        {
            
            groupIdList.append((groupIds[f].removeCharacters(from: CharacterSet.letters).removeCharacters(from: CharacterSet.punctuationCharacters)))
            
        }
        
        //        for f in stride(from: 0, to: loopBoundary+2, by: 12)
        //        {
        //            print(groupIds[f])
        //        }
        
        // TODO make an object with id and name of groups
        // Make an object array (perhaps struct) of these objects
        // Add a collection view cell for each struct and give the group the name
        
        
        return groupIdList
        
    }
    
    func getGroupNames(groups: String) -> [String]
    {
        let groups=groups
        var groupNameList = [String]()
        var groupNames = groups.components(separatedBy: ",")
        let loopBoundary = groupNames.count/2 + 14
        //
        for f in stride(from: 1, to: loopBoundary, by: 12)
        {
            var token = (groupNames[f].components(separatedBy: ":"))
            
            groupNameList.append(token[1])
            
            
        }
        
        
        
        
        
        return groupNameList
        
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
//        
//        self.GroupCollectionView.delegate=self
//        self.GroupCollectionView.dataSource = self
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension String {
    
    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }
    
    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }
}

public class GroupObject {
    
    var groupId: String
    var groupName: String
    var groupImage: UIImage?
    
    init (groupId: String, groupName: String, groupImage: UIImage)
    {
        self.groupId = groupId
        self.groupName = groupName
        self.groupImage = groupImage
    }
    func getId () -> String {
        return self.groupId
    }
    func getName () -> String {
        return self.groupName
    }
    func getImage () -> UIImage {
        return self.groupImage!
    }
    
    
}

