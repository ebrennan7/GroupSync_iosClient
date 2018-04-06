//
//  ProfileViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit
import Foundation

var changedPicture: Bool = false

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var middlePositionEditPopUp: NSLayoutConstraint!
    let editProfileModel = EditProfileModel()
    var nameString: String!
    var emailString: String?
    let defaultURLString = "https://s3-eu-west-1.amazonaws.com/groupsync-eu-images/public/images/missing.png"
    private var imageNeedsReload:Bool  = false
    
    let userInfo = UserDefaults.standard
    
    
    
    @IBAction func logOutButtonPressed()
    {
        createAlert(title: "Are you sure you want to log out?", message: "",option: true)
    }
    
    
    func createAlert(title:String, message: String, option: Bool)
    {
        let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        
        if(option)
        {
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                
                //log out happens
                
                
                self.clearUserDefaults()
                
                if let loginView = self.storyboard?.instantiateViewController(withIdentifier: "loginView"){
                    self.present(loginView, animated: true, completion: nil)
                }

                
            }))
            
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
                
                
            }))
            
        }
        else{
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in alert.dismiss(animated: true, completion: nil)
            }
            ))}
        self.present(alert, animated: true, completion: nil)
        
    }
    func clearUserDefaults()
    {
        let userInfo = UserDefaults.standard
        userInfo.removeObject(forKey: "userSignedIn")
        userInfo.synchronize()
    }
    
    @IBOutlet weak var middlePositionPopUp: NSLayoutConstraint!
    
    
    func setUserDetails()
    {
        let firstName = (userInfo.object(forKey: "firstName") as? String)?.removeCharacters(from: "\"")
        let secondName = (userInfo.object(forKey: "secondName") as? String)?.removeCharacters(from: "\"")
        
        
        
        
        
        nameString = ("\(firstName!) \(secondName!)")
        emailString = (userInfo.object(forKey: "email") as? String)?.removeCharacters(from: "\"")
    }
    
    @IBAction func editPhoto()
    {
        
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum))
        {
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true,completion: nil)
            
            
        }
        
        func imagePickerController(picker: UIImagePickerController!, didFinishPicking image: UIImage!, editingInfo: NSDictionary!)
        {
            self.dismiss(animated: true, completion: {() -> Void in
                
            })
            
            
            
        }
        cancelPopUp()
    }
    
    @IBAction func editProfile()
    {
        middlePositionEditPopUp.constant=0;
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func closeEditPopUp(_ sender: UIButton) {
        
        nameField.text = nameEdit.text
        emailField.text = emailEdit.text
        
        if((emailField.text?.isValidEmail())!&&nameField.text! != ""){
            editProfileModel.editDetails(name: nameField.text!, email: emailField.text!.lowercased())
        }
        else{
            createAlert(title: "Invalid Name or Email", message: "",option: false)
        }
        
        middlePositionEditPopUp.constant = 1200 * -1
        cancelPopUp()
        
        UIView.animate(withDuration: 0.5, animations: {self.view.layoutIfNeeded()
            
        })
    }
    
    
    let grayView = UIView()
   
    @IBOutlet weak var profilePictureView: UIImageView!
    var imagePicker = UIImagePickerController()
    
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            editProfileModel.changeProfilePhoto(image: image, completion: {
                
                success in
                
                if success {
                    let url = "https://s3-eu-west-1.amazonaws.com/groupsync-eu-images/public/avatars/\(self.userInfo.object(forKey: "userID")!)/profilePhoto.jpg)"
                    self.downloadImage(url: URL(string: url)!)
                    self.imageNeedsReload=true
                    
                }
                
                
                
            })
        }
        else
        {
            print("couldnt be represented as an image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
   
    @IBAction func cancelPopUp()
    {
        middlePositionPopUp.constant=1200
        
        UIView.animate(withDuration: 0.5, animations: {self.view.layoutIfNeeded()
            self.dimScreenView.alpha=0;
        })
        
        
        
        
    }
    
    @IBAction func buttonPressed()
    {
        
        
        
        middlePositionPopUp.constant=0;
        
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.dimScreenView.alpha=0.5;
        })
        
    }
    //
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var dimScreenView: UIView!
    
    override func viewDidLoad() {
        
        URLCache.shared.removeAllCachedResponses() //In case of new profile picture upload , delete the old cached image
        
        self.nameEdit.delegate=self
        self.emailEdit.delegate=self
        super.viewDidLoad()
        setUserDetails()
        
        nameField.text = nameString
        emailField.text = emailString
        
        popUpView.layer.masksToBounds = true;
        popUpView.layer.cornerRadius = 10;
        
        
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        profilePictureView.clipsToBounds = true
//        let fileName = ((userInfo.object(forKey: "fileName")!) as! String).removeCharacters(from: "\"")
        let userId = (userInfo.object(forKey: "userID")!)
        var urlString: String = "null"

   
        urlString = "https://s3-eu-west-1.amazonaws.com/groupsync-eu-images/public/avatars/\(userId)/profilePhoto.jpg"

        
        let url = URL(string: urlString)

        
        profilePictureView.contentMode = .scaleAspectFit
        downloadImage(url: url!)
        
        
    }
    func getImageFromWeb(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
    {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data,response,error)
            }.resume()
        
    }
    
    func downloadImage(url: URL){
        getImageFromWeb(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if(data.description == "306 bytes") // S3 needs another call
            {
                self.downloadImage(url: url)
            }
            
            
            DispatchQueue.main.async() {
                self.profilePictureView.image = UIImage(data: data)
                
                
                
                if(self.imageNeedsReload)
                {
                    self.imageNeedsReload=false
                    self.viewDidLoad()
                }
                
            }
     
        }
    }
    
    // Do any additional setup after loading the view.
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

