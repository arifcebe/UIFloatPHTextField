//
//  ViewController.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var test: UIFloatPHTextField!
    @IBOutlet weak var password: UIFloatPHTextField!
    @IBOutlet weak var autocomplete: UIDropdownTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.test.isUnderline = false
        self.password.isUnderline = false
        self.password.secureButtonTintColor = UIColor.red
//        let item1: UIDropdownTextField.Item = UIDropdownTextField.Item(data: ["text":"Indonesia","value":"id"])
//        let item2: UIDropdownTextField.Item = UIDropdownTextField.Item(data: ["text":"Singapore","value":"sg"])
//        let items:[UIDropdownTextField.Item] = [item1, item2]
//        self.autocomplete.items.append(contentsOf: items)
        self.autocomplete.dropdownButtonTintColor = UIColor.red
        self.autocomplete.isUnderline = true
//        self.autocomplete.isThumbnail = fa
        self.autocomplete.mapDictionary.image = ""
        self.autocomplete.mapDictionary.text = "name"
        self.autocomplete.mapDictionary.value = "id"
        self.autocomplete.fetchItemsFrom(ulrString: "https://bahaso.com/api/v2/countries")
        
//        DispatchQueue.global(qos: .background).async {
//            var items:[Item<ItemImage>] = []
//            if let country_path = Bundle.main.path(forResource: "countries", ofType: "plist") {
//                let array:NSArray = NSArray(contentsOfFile: country_path)!
//                for item in array {
//                    let _item: [String:Any] = item as! [String:Any]
//                    var data:[String:Any] = [:]
//                    data["text"] = _item["name"]
//                    data["value"] = _item["iso"]
//                    data["image"] = _item["image"]
//                    let __item: Item<ItemImage> = Item<ItemImage>(data:data)
//                    items.append(__item)
//                }
//                
//            }
//            
//            DispatchQueue.main.async {
//                self.autocomplete.items.append(contentsOf: items)
//                print("This is run on the main queue, after the previous code in outer block")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}

