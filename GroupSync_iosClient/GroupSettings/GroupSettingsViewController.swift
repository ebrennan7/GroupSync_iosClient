//
//  GroupSettingsViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 26/02/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class GroupSettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var userNames = [String]()
    var groupId: String!
    @IBOutlet weak var usersCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userNames.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupMembers_cell", for: indexPath) as! UsersCollectionViewCell
        
        cell.userName.text = userNames[indexPath.row]
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let getGroupUsers = GetGroupUsers()
        
        (getGroupUsers.getUserDetails(group_id: groupId)
            
        {(returnValue)
            in self.userNames = (returnValue)
        })
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.usersCollectionView.delegate=self
        self.usersCollectionView.dataSource = self
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
