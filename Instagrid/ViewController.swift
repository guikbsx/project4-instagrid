//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Bisiaux on 23/04/2020.
//  Copyright © 2020 guik development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Title View
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var shareLbl: UILabel!
    
    private var imagePicker = UIImagePickerController()

    private var buttonId: Int!

    //Center View
    @IBOutlet var photoButtons: [UIButton]!
    @IBAction func photoClicked(_ sender: UIButton) {
        changePhoto()
        buttonId = sender.tag
    }
    
    //Choose View
    @IBAction func layoutClicked(_ sender: UIButton) {
        changePreview(tag: sender.tag)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareLbl.font = R.font.delmMedium(size: 30)
        photoButtons.forEach {
            $0.imageView?.contentMode = .scaleAspectFill
        }
    }
    
    ///iPhone is on landscape or portrait ?
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            shareLbl.text = "Swipe left to share"
            arrowImg.image = R.image.arrowLeft()
        } else {
            print("Portrait")
            shareLbl.text = "Swipe up to share"
            arrowImg.image = R.image.arrowUp()
        }
    }
    
    private func changePhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func changePreview(tag: Int) {
        photoButtons.forEach {
            $0.isHidden = false
        }
        if tag != 3 {
            photoButtons[tag].isHidden = true
        }
    }

}

extension ViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            imagePicker.cameraDevice = .front
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoButtons[buttonId].setImage(editedImage, for: .normal)
        }

        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: - Choose image from camera roll

    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
