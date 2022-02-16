//
//  AlertController.swift
//  ChatApplication
//
//  Created by iPHSTech31 on 12/02/22.
//

import Foundation
import UIKit

public func alertBoxWithOneButton(title:String = "Error!", message:String, buttonTitle:String = "Ok") -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
   return alert
}

public func alertBoxWithTwoButton(title:String, message:String, buttonTitle:String) -> UIAlertController{
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
   return alert
}

