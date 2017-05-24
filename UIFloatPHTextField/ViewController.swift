//
//  ViewController.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var test: UIFloatPHTextfield!
    @IBOutlet weak var password: UIFloatPHTextfield!
    @IBOutlet weak var autocomplete: UIDropdownTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.test.isUnderline = false
        self.password.isUnderline = false
        let item1: UIDropdownTextField.Item = UIDropdownTextField.Item(data: ["text":"Indonesia","value":"id"])
        let item2: UIDropdownTextField.Item = UIDropdownTextField.Item(data: ["text":"Singapore","value":"sg"])
        let items:[UIDropdownTextField.Item] = [item1, item2]
        self.autocomplete.items.append(contentsOf: items)
//        self.autocomplete.fetchItemsFrom(ulrString: "http://localhost/countries.php")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }

}

