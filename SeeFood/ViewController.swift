//
//  ViewController.swift
//  SeeFood
//
//  Created by Abraham Wachsman on 7/16/20.
//  Copyright © 2020 Abraham Wachsman. All rights reserved.
//

import UIKit
import CoreML
import Vision

// Declare viewController as the delegate for 2 protocols 1) for images, add UIImagePickerControllerDelegate; this in turn requires 2) UINavigationControllerDelegate.
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    // Create a new imagePickerController object
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all properties
        // 1. set imagePicker's delegate as the current class (i.e. self)
        imagePicker.delegate = self
        
        // 2. Set the type of picker interface to be displayed by the controller, in this case, camera, if available, otherwise(esp. if running in Simulator, a savedPhotoAlbum
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .savedPhotosAlbum
        }
        
        
        // 3. Set the property for image editing to false, for simplicity.  If you wanted to allow the user to crop or apply effects, you'd set it to true.
        imagePicker.allowsEditing = false
        
        
    }

    // Here we specify what should happen when an image is either taken via camera or chosen from the photo library.  It tells the delegate that the user picked an image or movie
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 1. Verify that an image was in fact picked, i.e. not nil; To do this, must tap into the info parameter and specify the key for the imge that was picked. Since InfoKey has a datatype of Any, want to ensure that we're actually getting an image in return - hence, we downcast as UIImage. With this let constant, we have a way to access the image picked by user
        
        // 2. Downcast from Any to UIImage.  If successful,set the imageView image to the image chosen by the user.
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
        }
        
        //3. Dismiss the imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //The cameraTapped IBAction is the logical point for when image should appear, either from camera or from photo library
        present(imagePicker, animated: true, completion: nil)
    }
    
}

