//
//  GroupsView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation


class PrivateGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    let groupModel = GroupModel()
    var privateGroupTuples:[(group_id: Int, name: String)] = []
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! PrivateGroupCollectionViewCell
        
        cell.groupName = privateGroupTuples[indexPath.row].name
        cell.groupNameLabel.text! = privateGroupTuples[indexPath.row].name
        cell.groupId = String(privateGroupTuples[indexPath.row].group_id)
        
        //        print("Names\(PrivateGroupViewController.GN.getNames().count)")
        ////        print(GroupViewController.GI.getIds().count)
        //
        //
        //        if(PrivateGroupViewController.GN.getNames().count>=1)
        //        {
        //            cell.groupNameLabel.text! = PrivateGroupViewController.GN.getNames()[indexPath.row].removeCharacters(from: "\"")
        //            cell.groupId = PrivateGroupViewController.GI.getIds()[indexPath.row]
        //            cell.groupName = PrivateGroupViewController.GN.getNames()[indexPath.row].removeCharacters(from: "\"")
        //            cell.cellImage.tag = indexPath.row
        //
        //
        //        }
       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idOfCell = String(privateGroupTuples[indexPath.row].group_id)
        print(idOfCell)
        self.performSegue(withIdentifier: "showMap", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var mapController = segue.destination as! MapViewController
        mapController.currentGroupId = idOfCell
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        loading.hidesWhenStopped=true
        loading.stopAnimating()
        if(privateGroupTuples.count<1)
        {
            return 0
        }
        else{
            return privateGroupTuples.count
        }
        
        //        collectionView.reloadData()
        
        //        print(GroupViewController.GI.getIds())
        //        if(PrivateGroupViewController.GN.getNames().count<1)
        //        {
        //            loading.hidesWhenStopped=true
        //            loading.stopAnimating()
        //            return 0
        //        }
        //        else{
        //            return PrivateGroupViewController.GN.getNames().count
        //        }
        
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    var idOfCell: String?
    //    static var GI = GroupIds()
    //    static var GN = GroupNames()
    //
    //
    //
    
    //    func getGroups()
    //    {
    //        let userInfo = UserDefaults.standard
    //        let headers = [
    //            "Content-Type": "application/json",
    //            "Cache-Control": "no-cache",
    //            "Postman-Token": "54b3a185-141b-a74b-dcf1-5073dcd82fc0"
    //        ]
    //        let parameters = [
    //            "authToken": KeychainService.loadPassword()!,
    //            "user_id": userInfo.object(forKey: "userID")!
    //            ] as [String : Any]
    //
    //        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    //        guard postData != nil else {
    //            return
    //        }
    //
    //        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/get_groups")! as URL,
    //                                          cachePolicy: .useProtocolCachePolicy,
    //                                          timeoutInterval: 10.0)
    //        request.httpMethod = "POST"
    //        request.allHTTPHeaderFields = headers
    //        request.httpBody = postData
    //
    //        let session = URLSession.shared
    //        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
    //            if (error != nil) {
    //                print(error!)
    //            } else {
    //
    //                do {
    //                    let resultJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:AnyObject]
    //
    //                    DispatchQueue.main.async {
    //
    //                        if let dictionary = resultJson {
    //                            if let nestedDictionary = dictionary["data"] as? [String: Any]{
    //                                if let groups = nestedDictionary["groups"] as? String{
    //                                    var result = self.getObjects(groupId: self.getGroupIds(groups: groups), groupName: self.getGroupNames(groups: groups), groupImage: #imageLiteral(resourceName: "Groups"))
    //
    //
    //
    //
    //
    //
    //                                    PrivateGroupViewController.GI = GroupIds()
    //                                    PrivateGroupViewController.GI.setId(groups: self.getGroupIds(groups: groups))
    //
    //                                    PrivateGroupViewController.GN = GroupNames()
    //                                    PrivateGroupViewController.GN.setNames(groups: self.getGroupNames(groups: groups))
    //
    //
    //
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //                catch {
    //                    print("Error -> \(error)")
    //                }
    //            }
    //        })
    //
    //        dataTask.resume()
    //    }
    //    func getObjects(groupId: [String], groupName: [String], groupImage: UIImage?) -> [GroupObject]
    //    {
    //        var groupList = [GroupObject]()
    //        print(groupId.count)
    //        if(groupId.count>1)
    //        {
    //            for f in 0..<groupId.count{
    //                groupList.append(GroupObject.init(groupId: groupId[f], groupName: groupName[f], groupImage: #imageLiteral(resourceName: "Groups")))
    //            }
    //        }
    //
    //        return groupList
    //    }
    
    //    func getGroupIds(groups: String) ->  [String]
    //    {
    //
    //        let groups=groups
    //
    //        var groupIds = groups.components(separatedBy: ",")
    //
    //
    //        var groupIdList = [String]()
    //
    //
    //        for f in stride(from: 0, to: groupIds.count, by: 12)
    //        {
    //            groupIdList.append((groupIds[f].removeCharacters(from: CharacterSet.letters).removeCharacters(from: CharacterSet.punctuationCharacters)))
    //
    //        }
    //
    //
    //        return groupIdList
    //
    //    }
    //
    //    func getGroupNames(groups: String) -> [String]
    //    {
    //        let groups=groups
    //        var groupNameList = [String]()
    //        var groupNames = groups.components(separatedBy: ",")
    //
    //        for f in stride(from: 1, to: groupNames.count, by: 12)
    //        {
    //            var token = (groupNames[f].components(separatedBy: ":"))
    //
    //            groupNameList.append(token[1])
    //
    //
    //        }
    //
    //
    //
    //
    //        return groupNameList
    //
    //
    //
    //
    //
    //    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        //        getGroups()
        
        getPrivateGroups()
        
        
        sendLocation.determineCurrentLocation()
        
        
        
        
        
        
        //        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Do any additional setup after loading the view.
    }
    func getPrivateGroups()
    {
        groupModel.getPrivateGroups(completionBlock: { privateTuples in
            
            self.privateGroupTuples=privateTuples
            
            print("Got tuples")
            DispatchQueue.main.async {
                
                self.GroupCollectionView.delegate=self
                self.GroupCollectionView.dataSource = self
            }
            self.updateCollectionView()
            
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateCollectionView()
    {
        DispatchQueue.main.async {
            
            
            self.GroupCollectionView.reloadData()
        }
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
//public class GroupIds {
//
//    var groupIds = [String]()
//
//    func setId(groups: [String])
//    {
//        groupIds=groups
//    }
//    func getIds() -> [String]
//    {
//        return groupIds
//    }
//}
//public class GroupNames {
//    var groupNames = [String]()
//
//    func setNames(groups: [String])
//    {
//        groupNames = groups
//
//    }
//    func getNames() -> [String]
//    {
//        return groupNames
//    }
//}
//
//public class GroupObject {
//
//    var groupId: String
//    var groupName: String
//    var groupImage: UIImage?
//
//    init (groupId: String, groupName: String, groupImage: UIImage)
//    {
//        self.groupId = groupId
//        self.groupName = groupName
//        self.groupImage = groupImage
//    }
//    func getId () -> String {
//        return self.groupId
//    }
//    func getName () -> String {
//        return self.groupName
//    }
//    func getImage () -> UIImage {
//        return self.groupImage!
//    }
//



