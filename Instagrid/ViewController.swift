//
//  ViewController.swift
//  Instagrid
//
//  Created by Guillaume Bisiaux on 23/04/2020.
//  Copyright © 2020 guik development. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var arrowImg: UIImageView!
    @IBOutlet weak var shareLbl: UILabel!

//    @IBOutlet weak var layoutOneView: LayoutOneView?
//    @IBOutlet weak var layoutTwoView: LayoutTwoView?
//    @IBOutlet weak var layoutThreeView: LayoutThreeView?
    
    @IBOutlet weak var layoutOneView: UIView!
    @IBOutlet weak var layoutTwoView: UIView!
    @IBOutlet weak var layoutThreeView: UIView!
    
    @IBOutlet weak var chooseView: UIView!
    @IBOutlet weak var layout1Button: UIButton!
        
    @IBAction func layoutOneButton(_ sender: Any) {
        layoutOneView?.isHidden = false
        layoutTwoView?.isHidden = true
        layoutThreeView?.isHidden = true
    }
    
    @IBAction func layoutTwoButton(_ sender: Any) {
        layoutOneView?.isHidden = true
        layoutTwoView?.isHidden = false
        layoutThreeView?.isHidden = true

    }
    
    @IBAction func layoutThreeButton(_ sender: Any) {
        layoutOneView?.isHidden = true
        layoutTwoView?.isHidden = true
        layoutThreeView?.isHidden = false

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        //layoutOneView?.delegate = self
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
    
    private func configure() {
        shareLbl.font = R.font.delmMedium(size: 30)
        layoutOneView?.isHidden = false
        layoutTwoView?.isHidden = true
        layoutThreeView?.isHidden = true
    }

}

extension ViewController: ButtonsDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func buttonSelected(sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        print("im here")
        let actionSheet = UIAlertController(title : "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        print("im hhhhhere")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        print("im here")
    
        //layoutOneView?.buttons[0].imageView?.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

