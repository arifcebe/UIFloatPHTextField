//
//  UIFloatPHTextField.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

public class UIFloatPHTextField: UITextField {
    private var length: NSInteger {
        get {
            let _text: String = self.text ?? ""
//            return _text.characters.count
            return _text.count
        }
    }
    
    internal enum UIlabelAnimationType {
        case show
        case hide
    }
    
    override public var placeholder: String?{
        didSet{
            self.label.text = self.placeholder
            self.label.sizeToFit()
        }
        willSet{
        
        }
    }
    
    private let nc = NotificationCenter.default
    
    private var label: UILabel!
    
    private var flPointX: CGFloat = 5
    
    public var labelTextPassiveColor: UIColor = UIColor.black
    public var labelTextActiveColor: UIColor = UIColor.black
    
    private var storedText: String = ""
    
    private var secureTextFieldButton: UIButton!
    
    public var isUnderline: Bool = false {
        didSet {
            self.underlineView.isHidden = !self.isUnderline
        }
    }
    
    public var underlineColor: UIColor = UIColor.black {
        didSet{
            self.underlineView.backgroundColor = self.underlineColor
        }
    }
    
    private var didChangeSecureTextField: Bool = false
    
    private var underlineView: UIView!
    
    public var secureButtonTintColor: UIColor = UIColor.black {
        didSet{
            if self.isSecureTextEntry && self.secureTextFieldButton != nil {
                self.secureTextFieldButton.imageView?.tintColor = self.secureButtonTintColor
            }
        }
    }
    
    // MARK: init
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    // MARK: -
    
    
    // MARK: setup
    internal func setup(){
        self.clipsToBounds = false
        
        self.labelTextPassiveColor = UIColor.lightGray
        self.labelTextActiveColor = UIColor.black
        
        self.setupTextField()
        
        self.setuplabel()
        
        self.setupSecureTextFieldButton()
        
        self.setupUnderlineView()
        
        self.isUnderline = false
    }
    
    private func setuplabel(){
        if self.label != nil {
            return
        }
        
        self.label = UILabel()
        self.label.textColor = UIColor.black
        self.label.font = UIFont.boldSystemFont(ofSize: 12)
        self.label.center = CGPoint(x: self.flPointX, y: 0)
        self.label.alpha = 0
        
        self.label.text = self.placeholder
        self.label.sizeToFit()
        self.label.textAlignment = self.textAlignment
        
        self.addSubview(self.label)
    }
    
    private func setupTextField(){
        self.textAlignment = .left
        self.nc.addObserver(self, selector: #selector(UIFloatPHTextField.textDidChange), name: UITextField.textDidChangeNotification, object: nil)
        self.clearsOnBeginEditing = false
    }
    
    private func setupSecureTextFieldButton(){
        if self.secureTextFieldButton != nil {
            return
        }
        
        if self.isSecureTextEntry {
            let bundle: Bundle = Bundle(for: self.classForCoder)
            self.secureTextFieldButton = UIButton(type: .custom)
            
            let imageInvisible: UIImage = UIImage(named: "visible", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
            self.secureTextFieldButton.setImage(imageInvisible, for: .normal)
            let imageVisible: UIImage = UIImage(named: "invisible", in: bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate) ?? UIImage()
            self.secureTextFieldButton.setImage(imageVisible, for: .selected)
            self.secureTextFieldButton.setImage(nil, for: .highlighted)
            self.secureTextFieldButton.imageView?.contentMode = .center
            self.secureTextFieldButton.imageView?.tintColor = UIColor.black
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
        self.underlineView.backgroundColor = self.labelTextPassiveColor
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
    
    @objc internal func tapSecureTextField(sender: UIButton) {
        self.secureTextFieldButton.isSelected = self.isSecureTextEntry
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.didChangeSecureTextField = self.isSecureTextEntry
        
        let _text: String = self.text ?? ""
        let attributedString:NSMutableAttributedString = NSMutableAttributedString(string: _text)
        attributedString.addAttribute(NSAttributedString.Key.font, value: self.font!, range: NSMakeRange(0, self.length))
        self.attributedText = attributedString
    }
    
    deinit {
        self.nc.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc internal func textDidChange(notification: Notification) {
        guard let object: UITextField = notification.object as? UITextField else {
            return
        }
        
        if self == object {
            //TODO: store cursor position
            let selRange: UITextRange = self.selectedTextRange!
            
            //TODO: fix for type font
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.text!)
            
            let _text: String = self.text ?? ""
            
            attributedString.addAttribute(NSAttributedString.Key.font, value: self.font!, range: NSMakeRange(0, self.length))
            self.attributedText = attributedString
            
            //TODO: set current position cursor
            self.selectedTextRange = selRange
            
            if _text != "" {
                self.storedText = _text
                if self.label.alpha == 0 {
                    self.togglelabelAnimatanionType(.show)
                }
            } else {
                if self.didChangeSecureTextField {
                    self.didChangeSecureTextField = false
                    self.text = storedText
                    return
                }
                if self.label.alpha != 0 {
                    self.togglelabelAnimatanionType(.hide)
                }
                self.storedText = ""
            }
        }
    }
    
    private func togglelabelPropertiesWith(animationType: UIlabelAnimationType) {
        self.label.alpha = (animationType == .show) ? 1 : 0
        let flPointY: CGFloat = (animationType == .show) ? 0 : 0.5 * self.frame.height
        
        self.label.frame = CGRect(x: self.flPointX, y: flPointY, width: self.label.frame.width, height: self.label.frame.height)
    }
    
    private func togglelabelAnimatanionType(_ animationType: UIlabelAnimationType) {
        let easingOptions: UIView.AnimationOptions = animationType == .show ? .curveEaseOut : .curveEaseIn
        
        let combinedOptions: UIView.AnimationOptions = [.beginFromCurrentState, easingOptions]
        
        let duration: CGFloat = animationType == .show ? 0.25 : 0.05
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: combinedOptions, animations: { 
            self.togglelabelPropertiesWith(animationType: animationType)
        }, completion: nil)
    }
        
    private func labelInsets() -> UIEdgeInsets {
        let top: CGFloat = (self.length == 0) ? 0 : 10
        return UIEdgeInsets(top: top, left: 5, bottom: 0, right: 5)
    }
    // MARK: -
    
    // MARK: UITextField (Override)
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.labelInsets())
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: self.labelInsets())
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !self.isFirstResponder && self.length == 0 {
            self.togglelabelPropertiesWith(animationType: .hide)
        } else if self.length != 0 {
            self.togglelabelPropertiesWith(animationType: .show)
        }
        
        self.layoutUnderlineView()
    }
    // MARK: -
    
    // MARK: UIResponder (Override)
    override public func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            
            self.label.textColor = self.labelTextActiveColor
            
            self.underlineView.backgroundColor = self.labelTextActiveColor
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
    
    override public func resignFirstResponder() -> Bool {
        if self.canResignFirstResponder {
            self.label.textColor = self.labelTextPassiveColor
            
            self.underlineView.backgroundColor = self.labelTextPassiveColor
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
