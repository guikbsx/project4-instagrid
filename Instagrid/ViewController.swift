//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Bisiaux on 23/04/2020.
//  Copyright © 2020 guik development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var shareLbl: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet var photoButtons: [UIButton]!
    @IBOutlet var layoutButtons: [UIButton]!

    private var imagePicker = UIImagePickerController()
    private var isHighLighted:Bool = false
    private var buttonId: Int!
    
    @IBAction func photoClicked(_ sender: UIButton) {
        changePhoto()
        buttonId = sender.tag
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareLbl.font = R.font.delmMedium(size: 30)
        layoutButtons[2].isSelected = !layoutButtons[2].isSelected
        photoButtons.forEach { $0.imageView?.contentMode = .scaleAspectFill }
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragCenterView(_:)))
        centerView.addGestureRecognizer(panGestureRecognizer)
    }
    
    @IBAction func layoutClicked(_ sender: UIButton) {
        changePreview(tag: sender.tag)
        layoutButtons.forEach {
            if $0.tag == sender.tag {
                if !$0.isSelected {
                    $0.isSelected = !$0.isSelected
                }
            } else if $0.isSelected {
                $0.isSelected = !$0.isSelected
            }
        }
    }
    
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

extension ViewController {
    
    func specifyTranslation(gesture: UIPanGestureRecognizer) -> CGFloat {
        let translation = gesture.translation(in: centerView)
        
        if UIDevice.current.orientation.isLandscape {
            centerView.transform = CGAffineTransform(translationX: min(0, translation.x), y: 0)
            return translation.x
        } else {
            centerView.transform = CGAffineTransform(translationX: 0, y: min(0, translation.y))
            return translation.y
        }
    }
    
    @objc func dragCenterView(_ sender: UIPanGestureRecognizer) {
        let translation = specifyTranslation(gesture: sender)
        switch sender.state {
            case .began, .changed: break
            case .ended, .cancelled: share(translation: translation)
            default: break
        }
    }
    
    private func share(translation: CGFloat) {
        if translation > -200 {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.centerView.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        } else {
            photoButtons.forEach {
                if $0.imageView?.image == nil {
                    $0.setTitle("", for: .normal)
                }
            }
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                self.centerView.transform = UIDevice.current.orientation.isLandscape ? CGAffineTransform(translationX: -1000, y: 0) : CGAffineTransform(translationX: 0, y: -1000)
            })
            if let image = imageWithView(view: centerView) {
                let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
                self.present(vc, animated: true, completion: nil)
                vc.completionWithItemsHandler = { (_, _, _, _) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                        self.centerView.transform = CGAffineTransform(translationX: 0, y: 0)
                    })
                }
            }
            photoButtons.forEach {
                if $0.imageView?.image == nil {
                    $0.setTitle("+", for: .normal)
                }
            }
        }
    }

    func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        return UIGraphicsGetImageFromCurrentImageContext()
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
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            photoButtons[buttonId].setImage(editedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.isNavigationBarHidden = false
        self.dismiss(animated: true, completion: nil)
    }
}
