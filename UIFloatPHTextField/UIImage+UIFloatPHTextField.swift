//
//  UIImage+UIFloatPHTextField.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import UIKit

extension UIImage {
    static func imageWithColor (_ color: UIColor, bounds:CGRect) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        color.setFill()
        UIRectFill(bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
