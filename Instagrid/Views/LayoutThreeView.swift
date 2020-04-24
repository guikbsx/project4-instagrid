//
//  LayoutOneView.swift
//  Instagrid
//
//  Created by Guillaume Bisiaux on 23/04/2020.
//  Copyright © 2020 guik development. All rights reserved.
//

import UIKit

class LayoutThreeView: UIView {

    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        let bundle = Bundle.init(for: LayoutOneView.self)
        if let viewToAdd = bundle.loadNibNamed("LayoutThreeView", owner: self, options: nil), let contentView = viewToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
        
        buttons.forEach { button in
            button.backgroundColor = .white
            
            let plusImg: UIImageView = {
                let image = UIImageView(image: #imageLiteral(resourceName: "Plus"))
                image.translatesAutoresizingMaskIntoConstraints = false
                return image
            }()

            button.addSubview(plusImg)
            plusImg.centerXAnchor.constraint(equalTo: button.centerXAnchor).isActive = true
            plusImg.centerYAnchor.constraint(equalTo: button.centerYAnchor).isActive = true
            plusImg.widthAnchor.constraint(equalToConstant: 50).isActive = true
            plusImg.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
    }
}
