//
//  TextFieldExt.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import Foundation
import UIKit

enum Direction {
    case Left
    case Right
}

//MARK - textFieldExtension
extension UITextField {
    //MARK: - setPlaceholderAttributes
    public func setPlaceHolder(placeholderSting: String, foregroundColor:UIColor = .lightGray, size: CGFloat = 17) {
        self.attributedPlaceholder = NSAttributedString(string: placeholderSting, attributes: [
            .foregroundColor: foregroundColor,
            .font: UIFont.boldSystemFont(ofSize: size)
        ])
    }
    
    public func setupTextField(cornerRadius:CGFloat = 12, borderWidth:CGFloat = 1, borderColor:CGColor = UIColor.lightGray.cgColor, returnType:UIReturnKeyType = .continue) {
        self.layer.masksToBounds = false
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.returnKeyType = returnType
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.masksToBounds = true
    }
    
    
    
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = UIColor.clear.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }
    }
    
}



