//
//  ProfileViewController.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 04/12/2017.
//  Copyright © 2017 EmberBrennan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    
    @IBOutlet weak var nameField: UILabel!
    
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var middlePositionEditPopUp: NSLayoutConstraint!
    
    @IBOutlet weak var middlePositionPopUp: NSLayoutConstraint!
    

    func addDoneButton()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(LoginView.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.nameEdit?.inputAccessoryView = doneToolbar
        self.emailEdit?.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.nameEdit?.resignFirstResponder()
        self.emailEdit?.resignFirstResponder()
    }

    
    @IBAction func editPhoto()
    {
                if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum))
                {
                    print("BTN")
        
                    imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                    self.present(imagePicker,animated: true,completion: nil)
    
                    
        }
    
        func imagePickerController(picker: UIImagePickerController!, didFinishPicking image: UIImage!, editingInfo: NSDictionary!)
        {
            self.dismiss(animated: true, completion: {() -> Void in
    
            })
            profilePictureView.image = image
        

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
        
        middlePositionEditPopUp.constant = 1200 * -1
        cancelPopUp()
        
        UIView.animate(withDuration: 0.5, animations: {self.view.layoutIfNeeded()
    
        })
    }
    
    
    let grayView = UIView()

//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewLayout()
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = UIColor.white
//        return cv
//    }()
//    let cellID = "cellID"
    @IBOutlet weak var profilePictureView: UIImageView!
    var imagePicker = UIImagePickerController()
    
//    override convenience init( objectId : UIViewController ) {
//        self.init()
//        collectionView.dataSource = self
//        collectionView.delegate = self
//
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
//    }
 

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    func importImage()
//    {
//        let image = UIImagePickerController()
//        image.delegate = self
//
//        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
//
//        image.allowsEditing = false
//
//        self.present(image, animated: true)
//
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            profilePictureView.image = image
        }
        else
        {
            print("couldnt be repsented as an image")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
//    @IBAction func showSettings()
//    {
//        let grayView = UIView()
//        grayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//
//        grayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//
//        view.addSubview(grayView)
//        view.addSubview(collectionView)
//
//
//        let height: CGFloat = 200
//        let y = view.frame.height - height
//        collectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
//        grayView.frame = view.frame
//        grayView.alpha = 0
//
//        UIView.animate(withDuration: 0.5, animations:
//            { self.grayView.alpha = 1
//
//        self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//        })
//    }
//
//    @objc func handleDismiss()
//    {
//        UIView.animate(withDuration: 0.5, animations: {self.grayView.alpha = 0})
//    }
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
        super.viewDidLoad()
        
        self.addDoneButton()
        popUpView.layer.masksToBounds = true;
        popUpView.layer.cornerRadius = 10;
        
        
        
        profilePictureView.layer.cornerRadius = profilePictureView.frame.size.width/2
        profilePictureView.clipsToBounds = true

        let url = URL(string: "https://scontent-lht6-1.xx.fbcdn.net/v/t1.0-9/12047093_10204975005523992_2362019574812578826_n.jpg?oh=1534068ec897a748300517d63566909d&oe=5ACE079B" )
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if(error != nil)
            {
                print ("ERROR")
            }
            else{
                var documentsDirectory:String?
                var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            
                if(paths.count > 0)
                {
                    documentsDirectory=paths[0]
                    
                    let savePath = documentsDirectory! + "/profile.jpg"
                
                    
                    
                    
                    FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
                    DispatchQueue.main.async {
                        self.profilePictureView.image = UIImage(named: savePath)
                    }
                }
            }
        }
        task.resume()
    }
        
        // Do any additional setup after loading the view.
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath as IndexPath)
//        return cell
//    }



}
