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
    var admin: Bool?
    let groupInfo = GroupInformationModel()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return requestTuples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "invite_cell", for: indexPath) as! InvitesCollectionViewCell
        
        changeInviteShapes(cell: cell)
        
        requestModel.getTimeOfRequest(group_id: requestTuples[indexPath.row].group_id, completion: { time_since_invite in
            
            var calendar: Calendar = Calendar.current
            let dateFormatter = DateFormatter()
            //            dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss Z"
            dateFormatter.dateFormat = "MM dd,yyyy hh:mma"
            
            let currentDate = Date()
            let unitFlags = Set<Calendar.Component>([.day, .hour, .minute])
            calendar.timeZone = TimeZone(identifier: "UTC")!
            //
            //
            //            let timeSince = (calendar.dateComponents(unitFlags,  dateFormatter.date(from: time_since_invite[indexPath.row], to: currentDate)))
            //
            //
            
            let timeSinceInvite = calendar.dateComponents(unitFlags, from: dateFormatter.date(from: time_since_invite[indexPath.row])!, to: currentDate)
            
            
            print("INVITE\(dateFormatter.date(from: time_since_invite[indexPath.row]))")
            print(currentDate)
            
            DispatchQueue.main.async {
                
                if(timeSinceInvite.minute==1)
                {
                    cell.userNameCellLabel.text = "\(timeSinceInvite.minute!) minute ago"

                }
                else{
                    cell.userNameCellLabel.text = "\(timeSinceInvite.minute!) minutes ago"

                }
                if(timeSinceInvite.hour!>0)
                {
                    
                    
                    if(timeSinceInvite.hour==1)
                    {
                        cell.userNameCellLabel.text = "\(timeSinceInvite.hour!) hour ago"
                        
                    }
                    else{
                        cell.userNameCellLabel.text = "\(timeSinceInvite.hour!) hours ago"
                    }
           
                }
                if(timeSinceInvite.day!>0)
                {
                    if(timeSinceInvite.day==1)
                    {
                        cell.userNameCellLabel.text = "\(timeSinceInvite.day!) day ago"
                        
                    }
                    else{
                        cell.userNameCellLabel.text = "\(timeSinceInvite.day!) days ago"
                    }
                }
            }
            
            
        })
        
        
        cell.userNameCellLabel.text = "User \(requestTuples[indexPath.row].inviter_id)"
        
        groupInfo.getGroupName(group_id: String(requestTuples[indexPath.row].group_id), completion: { group_name in
            DispatchQueue.main.async {
                cell.groupNameCellLabel.text = group_name
            }
            
        })
        
        
        
        
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
    func changeInviteShapes(cell: UICollectionViewCell)
    {
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = cell.frame.size.width/24
        
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
                    self.performSegue(withIdentifier: "privateInvite", sender: nil)
                }
            }
            else{
                print("wasn't succesful")
            }
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let joinController = segue.destination as! JoinPublicGroupViewController
        joinController.cellID = String(idOfCell!)
        
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
