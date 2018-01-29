//
//  GroupCollectionViewCell.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/01/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var groupNameLabel: UILabel!
    var groupId: String = ""
    var groupName: String = ""
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        print(self.groupId)
        print(self.groupName)
    }
    
}
