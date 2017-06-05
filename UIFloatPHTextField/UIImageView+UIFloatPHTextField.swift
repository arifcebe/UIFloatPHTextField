//
//  UIImageView+UIFloatPHTextField.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func fph_setImageFromURL(_ URL:URL, placeholder: UIImage? = nil, failure fail : ((Error?) -> ())? = nil, success succeed : ((UIImage) -> ())? = nil) {
        let fetcher = Fetch<UIImage>(URL: URL)
        self.fph_setImage(fromFetcher: fetcher, placeholder: placeholder, failure: fail, success: succeed)
    }
    
    func fph_setImage(fromFetcher fetcher : Fetch<UIImage>,
                             placeholder : UIImage? = nil,
                             failure fail : ((Error?) -> ())? = nil,
                             success succeed : ((UIImage) -> ())? = nil) {
        self.image = placeholder
        self.fph_cancelSetImage()
        
        fetcher.request(failure: { [weak self] (error) in
//            if let strongSelf = self {
                fail?(error)
//            }
        }, success: { [weak self] (image) in
            if let strongSelf = self {
                strongSelf.fph_setImage(image, animated: true, success: succeed)
            }
        })
    }
    
    func fph_cancelSetImage() {
        
    }
    
    func fph_setImage(_ image : UIImage, animated : Bool, success succeed : ((UIImage) -> ())?) {
        if let succeed = succeed {
            succeed(image)
        } else if animated {
            UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.image = image
            }, completion: nil)
        } else {
            self.image = image
        }
    }
}
