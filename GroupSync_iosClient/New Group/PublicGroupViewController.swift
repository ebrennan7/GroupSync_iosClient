//
//  PublicGroupViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 10/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class PublicGroupViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var publicGroupCollectionView: UICollectionView!
    let groupModel = GroupModel()
    var publicGroupTuples:[(group_id: Int, name: String)] = []
    var idOfCell: String?
    var memberOfGroup: Bool?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(publicGroupTuples.count)
        if(publicGroupTuples.count<1)
        {
            return 0
        }
        else{
            return publicGroupTuples.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idOfCell = String(publicGroupTuples[indexPath.row].group_id)
        
        groupModel.checkIfMember(group_id: idOfCell!, completionBlock: {member in
            
            
            self.memberOfGroup=member
            
            
            DispatchQueue.main.async {
                
                if(!self.memberOfGroup!){
                    print("joining")
                    
                    self.performSegue(withIdentifier: "joinPageSegue", sender: nil)
                    
                }
                else{
                    print("skipping")
                    self.performSegue(withIdentifier: "skipToMap", sender: nil)
                }
            }
        })
        
        
        
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    
            if(!memberOfGroup!)
                {
                    let joinController = segue.destination as! JoinPublicGroupViewController
                    joinController.cellID = self.idOfCell
                }
                else{
                let mapController = segue.destination as! MapViewController
                    mapController.currentGroupId = self.idOfCell
                }
    
    
        }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "publicCollection_cell", for: indexPath) as! PublicGroupCollectionViewCell
        
        cell.groupNameLabel.text! = publicGroupTuples[indexPath.row].name
        cell.groupId = String(publicGroupTuples[indexPath.row].group_id)
        
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPublicGroups()
        
        sendLocation.determineCurrentLocation()

        // Do any additional setup after loading the view.
    }
    
    func getPublicGroups()
    {
        groupModel.getPublicGroups(completionBlock: { publicTuples in
            
            self.publicGroupTuples=publicTuples
            
            DispatchQueue.main.async {
                
            self.publicGroupCollectionView.delegate = self
            self.publicGroupCollectionView.dataSource = self
            }
            print(self.publicGroupTuples)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
       
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
