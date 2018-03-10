//
//  JoinPublicGroupViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 10/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import UIKit

class JoinPublicGroupViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var cellID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.text! = cellID!
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
