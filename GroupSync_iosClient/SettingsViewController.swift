//
//  SettingsViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 05/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var requestTuples:[(invite_id: Int, group_id: Int, inviter_id: Int, timeOfInvite: String)] = []
    
    @IBOutlet var invitesView: UIView!
    @IBOutlet weak var inviteCollectionView: UICollectionView!
    let requestModel = RequestModel()
    var idOfCell: Int?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestTuples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "invite_cell", for: indexPath) as! InvitesCollectionViewCell
        
        
        cell.userNameCellLabel.text = "User \(requestTuples[indexPath.row].inviter_id)"
        cell.groupNameCellLabel.text = "Group \( requestTuples[indexPath.row].group_id)"
        
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idOfCell = (requestTuples[indexPath.row].group_id)
        
        createInviteAlert(title: "Do you want to join this group?", message: "", group_id: idOfCell!, index: indexPath.row)
        
    }
    
    
    
    
    func createInviteAlert(title:String, message: String, group_id: Int, index: Int)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.acceptInvite(group_id: group_id, index: index)
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            
            self.declineInvite(group_id: group_id, index: index)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func getRequestsFromModel()
    {
        
        (requestModel.getRequests()
            {(returnValue)
                in self.requestTuples = (returnValue)
                
        })
        print(requestTuples)
    }
    
    override func viewDidLoad() {
        
        getRequestsFromModel()
        
        
        
        //        logOutButton.clipsToBounds = true
    }
    
    func acceptInvite(group_id: Int, index: Int)
    {
        requestModel.joinGroup(group_id: group_id, completion: { success in
            if(success)
            {
                DispatchQueue.main.async {
                    
                    print(index)
                    self.requestTuples.remove(at: index)
                    self.inviteCollectionView.reloadData()
                }
            }
            else{
                print("wasn't succesful")
            }
        })
    }
    func declineInvite(group_id: Int, index: Int)
    {
        
        requestModel.deleteRequest(group_id: group_id, completion: { success in
            if(success)
            {
                DispatchQueue.main.async {
                    
                    print(index)
                    self.requestTuples.remove(at: index)
                    self.inviteCollectionView.reloadData()
            
                }
                
            }
            else{
                print("Failed deleting group")
            }
            
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        self.inviteCollectionView.delegate=self
        self.inviteCollectionView.dataSource = self
    }
    
}
