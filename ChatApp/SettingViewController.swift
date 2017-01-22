//
//  SettingViewController.swift
//  ChatApp
//
//  Created by toco on 17/01/17.
//  Copyright © 2017 tocozakura. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  var backgroundImage: UIImage?
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var profileNameLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let ud = UserDefaults.standard.object(forKey: "profile_image") {
      //デコードして取り出す
      let decodeData = ud
      let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
      let decodedImage = UIImage(data: decodedData! as Data)
      
      profileImageView.image = decodedImage
      profileNameLabel.text = UserDefaults.standard.object(forKey: "name") as? String
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func openAlbum(_ sender: Any) {
    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
    }
  }
  
  @IBAction func launchCamera(_ sender: Any) {
    let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
    if UIImagePickerController.isSourceTypeAvailable(sourceType) {
      let cameraPicker = UIImagePickerController()
      cameraPicker.sourceType = sourceType
      cameraPicker.delegate = self
      self.present(cameraPicker, animated: true, completion: nil)
    }
  }
  
  @IBAction func back(_ sender: Any) {
    //保存をする
    if UserDefaults.standard.object(forKey: "back_image") != nil {
      let decodeData = UserDefaults.standard.object(forKey: "back_image")
      let decodedData = NSData(base64Encoded: decodeData as! String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
      let decodedImage = UIImage(data: decodedData as! Data)
      backgroundImage = decodedImage
    }
    if backgroundImage?.size.width != 0 {
      guard let backgroundImage = backgroundImage else {
        return
      }
      guard let data: NSData = UIImageJPEGRepresentation(backgroundImage, 0.1) as NSData? else { return }
      let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
      UserDefaults.standard.set(base64String, forKey: "back_image")
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      backgroundImage = pickedImage
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
