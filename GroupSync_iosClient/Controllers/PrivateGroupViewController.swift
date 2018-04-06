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

       
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        idOfCell = String(privateGroupTuples[indexPath.row].group_id)
   
        print(idOfCell)
        self.performSegue(withIdentifier: "showMap", sender: nil)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapController = segue.destination as! MapViewController
        mapController.currentGroupId = self.idOfCell
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

    }

    @IBOutlet weak var GroupCollectionView: UICollectionView!
    
    var idOfCell: String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.startAnimating()
        getPrivateGroups()
        
        sendLocation.determineCurrentLocation()
        // Do any additional setup after loading the view.
    }
    func getPrivateGroups()
    {
        groupModel.getPrivateGroups(completionBlock: { privateTuples in
            
            self.privateGroupTuples=privateTuples
            
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



