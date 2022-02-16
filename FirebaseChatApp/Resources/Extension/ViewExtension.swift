//
//  ViewExtension.swift
//  FirebaseChatApp
//
//  Created by vivek shrivastwa on 15/02/22.
//

import Foundation
import UIKit

//MARK: - UIView extension
extension UIView {
    
    public var width:CGFloat {
        return frame.size.width
    }
    
    public var height:CGFloat {
        return frame.size.height
    }

    public var top:CGFloat {
        return frame.origin.y
    }

    public var left:CGFloat {
        return frame.origin.x
    }

    public var bottom:CGFloat {
        return top + height
    }

    public var right:CGFloat {
        return left + width
    }

}
