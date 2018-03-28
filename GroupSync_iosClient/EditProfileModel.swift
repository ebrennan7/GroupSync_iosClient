//
//  EditProfileModel.swift
//  GroupSync_iosClient
//
//  Created by Ember Brennan on 28/03/2018.
//  Copyright © 2018 EmberBrennan. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSS3


class EditProfileModel{

    let userInfo = UserDefaults.standard

    var image: UIImage?
    
    func editDetails(name: String, email: String){
        
        
        //Split names into first and second for web app
        let firstName = name.split(separator: " ")[0]
        var lastName: String.SubSequence = ""
        if(name.split(separator: " ").count>1)
        {
        lastName = name.split(separator: " ")[1]
        }
        
        let headers = [
            "Content-Type": "application/json",
            "Cache-Control": "no-cache",
            "Postman-Token": "361320b9-7298-9bc4-5367-4fcae31de601"
        ]
        let parameters = [
            "user_id": userInfo.object(forKey: "userID")!,
            "name": firstName,
            "surname": lastName,
            "email": email,
            "password": userInfo.object(forKey: "password")!,
            "password_re_enter": userInfo.object(forKey: "password")!,
            "authToken": KeychainService.loadPassword()!,
            "image": ""
            ] as [String : Any]
        
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        guard postData != nil else{
            return
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: "http://groupsyncenv.rtimfc7um2.eu-west-1.elasticbeanstalk.com/edit_self")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {
                do{
                    if let resultJson = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
                    {
                        if let nestedDictionary = resultJson["success"] as? Int
                        {
                            if(nestedDictionary==1)
                            {
                                print("Success")
                                self.userInfo.set(firstName, forKey: "firstName")
                                self.userInfo.set(lastName, forKey: "secondName")
                                self.userInfo.set(email, forKey: "email")
                            }
                        }
                    }
                }
                catch{
                   print(error)
                }
            }
        })
        
        dataTask.resume()
        
        
    }

    
    func changeProfilePhoto(image: UIImage!)
    {
        self.image = image.squared
        uploadImage()
    }
    
    private func uploadImage() {
    
        print("Hello")

        let user_id = userInfo.object(forKey: "userID")!
            let fileManager = FileManager.default
            let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("test3.jpeg")
        let imageData = UIImageJPEGRepresentation(image!, 0)
            fileManager.createFile(atPath: path as String, contents: imageData, attributes: nil)
        
            let fileUrl = NSURL(fileURLWithPath: path)
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.bucket = "groupsync-eu-images"
        uploadRequest?.key = "public/avatars/\(user_id)/profilePhoto.jpg"
            uploadRequest?.contentType = "image/jpeg"
            uploadRequest?.body = fileUrl as URL!
        
            uploadRequest?.uploadProgress = { (bytesSent, totalBytesSent, totalBytesExpectedToSend) -> Void in
                DispatchQueue.main.async(execute: {
                    //                    print("totalBytesSent",totalBytesSent)
                    //                    print("totalBytesExpectedToSend",totalBytesExpectedToSend)
                    
                    //                    self.amountUploaded = totalBytesSent // To show the updating data status in label.
                    //                    self.fileSize = totalBytesExpectedToSend
                })
            }
        
            let transferManager = AWSS3TransferManager.default()
            transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
                if task.error != nil {
                    // Error.
                    print("error")
                } else {
                    // Do something with your result.
                    print("No error Upload Done")
                    self.userInfo.set(false, forKey: "profilePictureChanged")
                }
                return nil
            })
        }
    
    
}
extension UIImage {
    var isPortrait:  Bool    { return size.height > size.width }
    var isLandscape: Bool    { return size.width > size.height }
    var breadth:     CGFloat { return min(size.width, size.height) }
    var breadthSize: CGSize  { return CGSize(width: breadth, height: breadth) }
    var breadthRect: CGRect  { return CGRect(origin: .zero, size: breadthSize) }
    var squared: UIImage? {
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor((size.width - size.height) / 2) : 0, y: isPortrait  ? floor((size.height - size.width) / 2) : 0), size: breadthSize)) else { return nil }
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


