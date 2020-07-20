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
        // 1. Verify that an image was in fact picked, i.e. not nil; by tapping into info parameter and specify the key for the picked image. Since InfoKey has datatype of Any, must ensure that we're actually getting an image in return, so downcast as UIImage. Can use the let constant to access the image picked by user
        
        // 2. Downcast from Any to UIImage.  If successful,set the imageView image to the image chosen by the user.
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage
            
            // Convert UIImage into CIImage (Core Image Image). CIImage allows using Vision and CoreImage frameworks.  Adsd security using guard just in case conversion fails
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage to CIImage")
            }
            
            // Pass the above CIImage int to the detect method
            detect(image: ciimage)
        }
        
        //3. Dismiss the imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // The detect method below takes CIImage param (converted from UIImage) and gets the classification for it
    func detect(image: CIImage) {
        // Load the InceptionV3 model: create new object from InceptionV3 model,using VNCoreModel (which comes from Vision framework) as container for MLModel and tap into model property.  VNCoeewModel may throw an error, so preface it with try?  If it fails, it will return nil, otherwise return an optional.  To handle a nil, use a guard let
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loading CoreMLModel failed")
        }
        
        // If above guard did not return nil (thus no fatal error was produced), we can process the image
        let request = VNCoreMLRequest(model: model) { (request, error) in
            // Process result of request
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
            // Check the first element of results (usually has highest confidence)
            if let firstResult = results.first {
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                } else {
                    self.navigationItem.title = "Not hotdog!"
                }
            }
            
        }
        
        // Create a handler to handle image
        let handler = VNImageRequestHandler(ciImage: image)
        
        // Try using handler to perform the request.  Wrap this in a do-catch block
        do {
            try handler.perform([request])
        }
        catch {
            //Any errors are caught and processed here
            print(error)
        }
    }
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        //The cameraTapped IBAction is the logical point for when image should appear, either from camera or from photo library
        present(imagePicker, animated: true, completion: nil)
    }
    
}

