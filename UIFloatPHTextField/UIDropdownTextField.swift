//
//  UIDropdownTextField.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

public class UIDropdownTextField: UIFloatPHTextField {
    public struct Item {
        var text: String?
        var value: String?
        var image: UIImage?
        
        init(data:[String:Any]) {
            self.text = data["text"] as? String
            self.value = data["value"] as? String
            self.image = data["image"] as? UIImage
        }
    }
    
    public var items:[Item] = []
    fileprivate var isFilter: Bool = false
    fileprivate var itemsFilter:[Item] = []
    
    public var selectedItem: Item?
    public var value: String?
    
    private var listView: UITableView!
    
    private var dropdownTextFieldButton: UIButton!
    
    private let actLoading: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    fileprivate var imageView: UIImageView!
    
    private var dataTask: URLSessionDataTask?
    
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
    
    override func setup(){
        super.setup()
        
        self.setupDropdownButton()
        
        self.setupAutoCompleteTable()
        
        self.setupImageView()
    }
    
    override public var isUnderline: Bool {
        didSet{
            if let _ = self.listView {
                self.listView.layer.borderColor = self.isUnderline ? self.labelTextPassiveColor.cgColor : self.labelTextActiveColor.cgColor
            }
        }
    }
    
    private func setupAutoCompleteTable(){
        if self.listView != nil {
            return
        }
        
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.alpha = 0
        tableView.layer.borderColor = UIColor.clear.cgColor
        tableView.layer.borderWidth = 1
        
        tableView.contentInset = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        
        let x: CGFloat = self.frame.origin.x
        let y: CGFloat = self.frame.maxY
        let tableFrame: CGRect = CGRect(x: x, y: y, width: self.frame.width, height: 0)
        tableView.frame = tableFrame
        
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        self.listView = tableView
        self.listView.tableHeaderView = nil
    }
    
    func setupImageView(){
        if self.imageView != nil {
            return
        }
        self.imageView = UIImageView()
        self.imageView.frame = CGRect(x: 0, y: 0, width: 29, height: 16)
        self.leftViewMode = .always
    }
    
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.leftViewRect(forBounds: bounds)
        rect.origin.x = 15
        rect.origin.y = 18
        return rect
    }
    
    private func setupDropdownButton(){
        if self.dropdownTextFieldButton != nil {
            return
        }
        let bundle: Bundle = Bundle(for: self.classForCoder)
        self.dropdownTextFieldButton = UIButton(type: .custom)
        let imageInvisible: UIImage = UIImage(named: "dropdown", in: bundle, compatibleWith: nil) ?? UIImage()
        self.dropdownTextFieldButton.setImage(imageInvisible, for: .normal)
        self.dropdownTextFieldButton.imageView?.contentMode = .center
        self.dropdownTextFieldButton.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        self.rightView = self.dropdownTextFieldButton
        self.rightViewMode = .always
    }
    
    private func toggleDropdownPropertiesWith(animationType: UIlabelAnimationType) {
        self.listView.alpha = (animationType == .show) ? 1 : 0
        let tableViewHeight: CGFloat = (animationType == .show) ? 120 : 0
        self.listView.layer.borderColor = (animationType == .show) ? self.labelTextActiveColor.cgColor : self.labelTextPassiveColor.cgColor
        let borderColor: CGColor = self.listView.layer.borderColor ?? UIColor.clear.cgColor
        self.listView.layer.borderColor = self.isUnderline ? borderColor : UIColor.clear.cgColor
        var frame: CGRect = self.listView.frame
        frame.size.height = tableViewHeight
        self.listView.frame = frame
    }
    
    func toggleDropdownAnimationType(_ animationType: UIlabelAnimationType) {
        let easingOptions: UIViewAnimationOptions = animationType == .show ? .curveEaseOut : .curveEaseIn
        if animationType == .show {
            self.listView.removeFromSuperview()
            let index: NSInteger = superview?.subviews.count ?? 0
            self.superview?.insertSubview(self.listView, at: index)
        }
        let combinedOptions: UIViewAnimationOptions = [.beginFromCurrentState, easingOptions]
        
        let duration: CGFloat = animationType == .show ? 0.3 : 0.25
        UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: combinedOptions, animations: {
            self.toggleDropdownPropertiesWith(animationType: animationType)
        }, completion: nil)
    }

    private func layoutListView(){
        if let listView = self.listView {
            var frame: CGRect = listView.frame
            let width: CGFloat = self.frame.width
            frame.size.width = width
            listView.frame = frame
            listView.separatorStyle = .none
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutListView()
    }
    
    override public func becomeFirstResponder() -> Bool {
        if super.becomeFirstResponder() {
            self.toggleDropdownAnimationType(.show)
        }
        return false
    }
    
    override public func resignFirstResponder() -> Bool {
        if self.canResignFirstResponder {
            self.toggleDropdownAnimationType(.hide)
            
            if self.items.count != 0 {
                let item = self.items.filter({ (item: Item) -> Bool in
                    if item.text?.lowercased() == self.text?.lowercased() {
                        return true
                    }
                    return false
                }).first
                self.text = item?.text
                self.value = item?.value
                self.imageView.image = item?.image
                self.leftView = item?.image != nil ? self.imageView : nil
            }
            return super.resignFirstResponder()
        }
        return false
    }
    
    func fetchItemsFrom(ulrString: String) {
        self.listView.tableHeaderView = self.actLoading
        self.actLoading.startAnimating()
        let url: URL = URL(string: ulrString)!
        self.dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data {
                do{
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let _items:[Any] = result as? [Any] {
                        for _item in _items {
                            let __item:Item = Item(data: _item as! [String : Any])
                            self.items.append(__item)
                        }
                        self.listView.reloadData()
                        self.listView.tableHeaderView = nil
                    }
                } catch {
                    print(error)
                }
                self.actLoading.stopAnimating()
            }
        })
        self.dataTask?.resume()
    }
    
    override func textDidChange(notification: Notification) {
        super.textDidChange(notification: notification)
        guard let object: UITextField = notification.object as? UITextField else {
            return
        }
        
        if object == self {
            self.leftView = nil
            if self.text == nil || self.text == "" {
                self.isFilter = false
                self.listView.reloadData()
            } else {
                self.isFilter = true
                self.itemsFilter = []
                let objectText: String = self.text?.lowercased() ?? ""
                for item in self.items {
                    let _text: String = item.text?.lowercased() ?? ""
                    let itemRange: Range? = _text.lowercased().range(of: objectText)
                    if itemRange != nil {
                        self.itemsFilter.append(item)
                    }
                }
                self.listView.reloadData()
            }
        }
    }
}


extension UIDropdownTextField: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: Int = indexPath.row
        let item = self.isFilter ? self.itemsFilter[row] : self.items[row]
        self.text = item.text
        self.value = item.value
        self.imageView.image = item.image
        self.leftView = self.imageView
        self.endEditing(true)
    }
}

extension UIDropdownTextField: UITableViewDataSource {
    func createImage(_ image: UIImage, scaleToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFilter ? self.itemsFilter.count : self.items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "IdentifierCell")
        let row: Int = indexPath.row
        let item = self.isFilter ? self.itemsFilter[row] : self.items[row]
        if let image = item.image {
            cell.imageView?.image = self.createImage(image, scaleToSize: CGSize(width: 39, height: 26))
        }
        let text: String = item.text ?? ""
        cell.textLabel?.text = text
        return cell
    }
}
