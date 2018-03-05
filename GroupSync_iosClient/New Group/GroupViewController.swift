//
//  GroupsView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation


class GroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! GroupCollectionViewCell
        

        
        if(GroupViewController.GI.getIds().count>=1)
        {
            cell.groupNameLabel.text! = GroupViewController.GN.getNames()[indexPath.row].removeCharacters(from: "\"")
            cell.groupId = GroupViewController.GI.getIds()[indexPath.row]
            cell.groupName = GroupViewController.GN.getNames()[indexPath.row].removeCharacters(from: "\"")
            cell.cellButton.tag = indexPath.row
            
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idOfCell = (GroupViewController.GI.getIds()[indexPath.row])
        
        self.performSegue(withIdentifier: "showMap", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var mapController = segue.destination as! MapViewController
        mapController.currentGroupId = idOfCell
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        
        //        collectionView.reloadData()
        
        //        print(GroupViewController.GI.getIds())
        if(GroupViewController.GI.getIds().count<1)
        {
            return 0
        }
        else{
            return GroupViewController.GI.getIds().count
        }
        
        
    }
    
    
    
   
    
    
    
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    var idOfCell: String?
    static var GI = GroupIds()
    static var GN = GroupNames()
    
    
    
    
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
                                    var result = self.getObjects(groupId: self.getGroupIds(groups: groups), groupName: self.getGroupNames(groups: groups), groupImage: #imageLiteral(resourceName: "Groups"))
                                    
                                    
                                                                        print(groups)
                                    
                                    
                                    
                                    
                                    GroupViewController.GI = GroupIds()
                                    GroupViewController.GI.setId(groups: self.getGroupIds(groups: groups))
                                    
                                    GroupViewController.GN = GroupNames()
                                    GroupViewController.GN.setNames(groups: self.getGroupNames(groups: groups))
                                    
                                    
                                    
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
        print(groupId.count)
        if(groupId.count>1)
        {
            for f in 0..<groupId.count{
                groupList.append(GroupObject.init(groupId: groupId[f], groupName: groupName[f], groupImage: #imageLiteral(resourceName: "Groups")))
            }
        }
        
        return groupList
    }
    
    func getGroupIds(groups: String) ->  [String]
    {
        
        let groups=groups
        
        var groupIds = groups.components(separatedBy: ",")
        
        
        var groupIdList = [String]()
        
        
        for f in stride(from: 0, to: groupIds.count, by: 12)
        {
            groupIdList.append((groupIds[f].removeCharacters(from: CharacterSet.letters).removeCharacters(from: CharacterSet.punctuationCharacters)))
            
        }
        
        
        return groupIdList
        
    }
    
    func getGroupNames(groups: String) -> [String]
    {
        let groups=groups
        var groupNameList = [String]()
        var groupNames = groups.components(separatedBy: ",")
        
        for f in stride(from: 1, to: groupNames.count, by: 12)
        {
            var token = (groupNames[f].components(separatedBy: ":"))
            
            groupNameList.append(token[1])
            
            
        }
        
        
        
        
        return groupNameList
        
        
        
        
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.GroupCollectionView.delegate=self
        self.GroupCollectionView.dataSource = self
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGroups()
        
        
        
        sendLocation.determineCurrentLocation()

        
        
        
        
        
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
public class GroupIds {
    
    var groupIds = [String]()
    
    func setId(groups: [String])
    {
        groupIds=groups
    }
    func getIds() -> [String]
    {
        return groupIds
    }
}
public class GroupNames {
    var groupNames = [String]()
    
    func setNames(groups: [String])
    {
        groupNames = groups
        
    }
    func getNames() -> [String]
    {
        return groupNames
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

