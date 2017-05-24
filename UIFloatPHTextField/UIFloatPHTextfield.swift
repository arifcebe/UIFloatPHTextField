//
//  UIFloatPHTextfield.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

class UIFloatPHTextfield: UITextField {
    private var length: NSInteger {
        get {
            let _text: String = self.text ?? ""
            return _text.characters.count
        }
    }
    
    internal enum UIFloatLabelAnimationType {
        case show
        case hide
    }
    
    override var placeholder: String?{
        didSet{
            self.floatLabel.text = self.placeholder
            self.floatLabel.sizeToFit()
        }
        willSet{
        
        }
    }
    
    private let nc = NotificationCenter.default
    
    private var floatLabel: UILabel!
    
    private var flPointX: CGFloat = 15
    
    var flPassiveColor: UIColor = UIColor.black
    var flActiveColor: UIColor = UIColor.black
    
    private var storedText: String = ""
    
    private var secureTextFieldButton: UIButton!
    
    var isUnderline: Bool = false {
        didSet {
            self.underlineView.isHidden = !self.isUnderline
        }
    }
    
    private var didChangeSecureTextField: Bool = false
    
    internal var underlineView: UIView!
    
    private var autoCompleteTableView:UITableView!
    public var onSelect:(String, NSIndexPath)->() = {_,_ in}
    
    // MARK: init
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    // MARK: -
    
    
    // MARK: setup
    internal func setup(){
        self.clipsToBounds = false
        
        self.flPassiveColor = UIColor.lightGray
        self.flActiveColor = UIColor.blue
        
        self.setupTextField()
        
        self.setupFloatLabel()
        
        self.setupSecureTextFieldButton()
        
        self.setupUnderlineView()
        
        self.isUnderline = false
    }
    
    private func setupFloatLabel(){
        if self.floatLabel != nil {
            return
        }
        
        self.floatLabel = UILabel()
        self.floatLabel.textColor = UIColor.black
        self.floatLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.floatLabel.center = CGPoint(x: self.flPointX, y: 0)
        self.floatLabel.alpha = 0
        
        self.floatLabel.text = self.placeholder
        self.floatLabel.sizeToFit()
        self.floatLabel.textAlignment = self.textAlignment
        
        self.addSubview(self.floatLabel)
    }
    
    private func setupTextField(){
//        self.addTarget(self, action: #selector(textDidChange), for: UIControlEvents.editingChanged)
        self.textAlignment = .left
        self.nc.addObserver(self, selector: #selector(UIFloatPHTextfield.textDidChange), name: .UITextFieldTextDidChange, object: nil)
        self.clearsOnBeginEditing = false
    }
    
    
    
    private func setupSecureTextFieldButton(){
        if self.secureTextFieldButton != nil {
            return
        }
        
        if self.isSecureTextEntry {
            self.secureTextFieldButton = UIButton(type: .custom)
            let imageInvisible: UIImage = UIImage(named: "invisible") ?? UIImage()
            self.secureTextFieldButton.setImage(imageInvisible, for: .normal)
            let imageVisible: UIImage = UIImage(named: "visible") ?? UIImage()
            self.secureTextFieldButton.setImage(imageVisible, for: .selected)
            self.secureTextFieldButton.setImage(nil, for: .highlighted)
            self.secureTextFieldButton.imageView?.contentMode = .center
            self.secureTextFieldButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            self.rightView = self.secureTextFieldButton
            self.rightViewMode = .always
            
            //TODO: remove and add event
            self.secureTextFieldButton.removeTarget(self, action: nil, for: .touchUpInside)
            self.secureTextFieldButton.addTarget(self, action: #selector(self.tapSecureTextField), for: .touchUpInside)
        }
    }
    
    private func setupUnderlineView(){
        if self.underlineView != nil {
            return
        }
        
        self.underlineView = UIView()
        self.underlineView.translatesAutoresizingMaskIntoConstraints = false
        let pointY: CGFloat = self.frame.height - 1
        let width: CGFloat = self.frame.width
        
        self.underlineView.frame = CGRect(x: 0, y: pointY, width: width, height: 1)
        self.underlineView.backgroundColor = self.flPassiveColor
        self.addSubview(self.underlineView)
    }
    // MARK: -
    
    // MARK: Helper
    private func layoutUnderlineView(){
        if let underlineView = self.underlineView {
            var frame: CGRect = underlineView.frame
            let width: CGFloat = self.frame.width
            frame.size.width = width
            self.underlineView.frame = frame
        }
    }
    
    internal func tapSecureTextField(sender: UIButton) {
        self.secureTextFieldButton.isSelected = self.isSecureTextEntry
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.didChangeSecureTextField = self.isSecureTextEntry
        
        let _text: String = self.text ?? ""
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: _text)
        attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, self.length))
        self.attributedText = attributedString
    }
    
    deinit {
        self.nc.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    internal func textDidChange(notification: Notification) {
        guard let object: UITextField = notification.object as? UITextField else {
            return
        }
        
        if self == object {
            //TODO: store cursor position
            let selRange: UITextRange = self.selectedTextRange!
            
            //TODO: fix for type font
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            
            let _text: String = self.text ?? ""
            
            attributedString.addAttribute(NSFontAttributeName, value: self.font!, range: NSMakeRange(0, self.length))
            self.attributedText = attributedString
            
            //TODO: set current position cursor
            self.selectedTextRange = selRange
            
            if _text != "" {
                self.storedText = _text
                if self.floatLabel.alpha == 0 {
                    self.toggleFloatLabelAnimatanionType(.show)
                }
            } else {
                if self.didChangeSecureTextField {
                    self.didChangeSecureTextField = false
                    self.text = storedText
                    return
                }
                if self.floatLabel.alpha != 0 {
                    self.toggleFloatLabelAnimatanionType(.hide)
                }
                self.storedText = ""
            }
        }
    }
    
    private func toggleFloatLabelPropertiesWith(animationType: UIFloatLabelAnimationType) {
        self.floatLabel.alpha = (animationType == .show) ? 1 : 0
        let flPointY: CGFloat = (animationType == .show) ? 0 : 0.5 * self.frame.height
        
        self.floatLabel.frame = CGRect(x: self.flPointX, y: flPointY, width: self.floatLabel.frame.width, height: self.floatLabel.frame.height)
    }
    
    private func toggleFloatLabelAnimatanionType(_ animationType: UIFloatLabelAnimationType) {
        let easingOptions: UIViewAnimationOptions = animationType == .show ? .curveEaseOut : .curveEaseIn
        
        let combinedOptions: UIViewAnimationOptions = [.beginFromCurrentState, easingOptions]
        
        let duration: CGFloat = animationType == .show ? 0.25 : 0.05
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: combinedOptions, animations: { 
            self.toggleFloatLabelPropertiesWith(animationType: animationType)
        }, completion: nil)
    }
        
    private func floatLabelInsets() -> UIEdgeInsets {
        let top: CGFloat = (self.length == 0) ? 0 : 10
        return UIEdgeInsets(top: top, left: 15, bottom: 0, right: 5)
    }
    // MARK: -
    
    // MARK: UITextField (Override)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.textRect(forBounds: bounds), self.floatLabelInsets())
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(super.editingRect(forBounds: bounds), self.floatLabelInsets())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.isFirstResponder && self.length == 0 {
            self.toggleFloatLabelPropertiesWith(animationType: .hide)
        } else if self.length != 0 {
            self.toggleFloatLabelPropertiesWith(animationType: .show)
        }
        
        self.layoutUnderlineView()
    }
    // MARK: -
    
    // MARK: UIResponder (Override)
    override func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            self.floatLabel.textColor = self.flActiveColor
            
            self.underlineView.backgroundColor = self.flActiveColor
            var frame: CGRect = underlineView.frame
            frame.size.height = 2
            self.underlineView.frame = frame
            
            self.storedText = self.text ?? ""
            
            //TODO: for avoid clear text in secure text
            self.text = ""
            self.insertText(self.storedText)
            return true
        }
        
        return false
    }
    
    override func resignFirstResponder() -> Bool {
        if self.canResignFirstResponder {
            self.floatLabel.textColor = self.flPassiveColor
            
            self.underlineView.backgroundColor = self.flPassiveColor
            var frame: CGRect = underlineView.frame
            frame.size.height = 1
            self.underlineView.frame = frame
            
            super.resignFirstResponder()
            return true
        }
        return false
    }
    // MARK: -
}
