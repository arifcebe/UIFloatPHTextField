//
//  Item.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation
import UIKit

public protocol ItemConvertible {
    associatedtype TypeData
}

public enum ItemImage: ItemConvertible {
    public typealias TypeData = ItemImage

    case Image(UIImage)
    case Data(Data)
    case String(String)
    
    public static func dataType(_ dataType: Any?) -> TypeData? {
        switch (dataType) {
            case let image as UIImage:
                return ItemImage.Image(image)
            case let data as Data:
                return ItemImage.Data(data)
            case let string as String:
                return ItemImage.String(string)
            default:
                return nil
        }
    }
    
    public var image : UIImage! {
        switch (self) {
            case .Image(let image):
                return image
            default:
                return nil
        }
    }
    
    public var data : Data! {
        switch (self) {
            case .Data(let data):
                return data
            default:
                return nil
        }
    }
    
    public var string : String! {
        switch (self) {
            case .String(let string):
                return string
            default:
                return nil
        }
    }
}

public struct Item<T: ItemConvertible> {
    public var text: String?
    public var value: String?
    public var image: T?
    public var data:[String:Any]?
    public init(data:[String:Any]) {
        self.text = data["text"] as? String
        self.value = data["value"] as? String
        let itemImage = ItemImage.dataType(data["image"])
        self.image = itemImage as? T
        
        self.data = data
    }
}
