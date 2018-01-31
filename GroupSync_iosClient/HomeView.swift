//
//  HomeView.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class HomeView: UIViewController {

    @IBAction func groupsButton(_ sender: UIButton) {
        if let key = KeychainService.loadPassword()
        {
            print(key)
        }
        else{
            print("Error with Keychain")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.object(forKey: "userSignedIn") == nil {
            
            if let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as? ViewController {
                let navController = UINavigationController(rootViewController: loginView)
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    // Do any additional setup after loading the view.

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
