//
//  DataConvertible.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import UIKit

protocol DataConvertible {
    associatedtype Result
    
    static func convertFromData(_ data:Data) -> Result?
}

private let imageSync = NSLock()
extension UIImage : DataConvertible {
    public typealias Result = UIImage
    
    // HACK: UIImage data initializer is no longer thread safe. See: https://github.com/AFNetworking/AFNetworking/issues/2572#issuecomment-115854482
    static func safeImageWithData(_ data:Data) -> Result? {
        imageSync.lock()
        let image = UIImage(data:data, scale: scale)
        imageSync.unlock()
        return image
    }
    
    public class func convertFromData(_ data: Data) -> Result? {
        let image = UIImage.safeImageWithData(data)
        return image
    }
    
    fileprivate static let scale = UIScreen.main.scale
}

public enum JSON : DataConvertible {
    public typealias Result = JSON
    
    case Dictionary([String:AnyObject])
    case Array([AnyObject])
    
    public static func convertFromData(_ data: Data) -> Result? {
        do {
            let object : Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
            switch (object) {
            case let dictionary as [String:AnyObject]:
                return JSON.Dictionary(dictionary)
            case let array as [AnyObject]:
                return JSON.Array(array)
            default:
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    public var array : [AnyObject]! {
        switch (self) {
        case .Dictionary(_):
            return nil
        case .Array(let array):
            return array
        }
    }
    
    public var dictionary : [String:AnyObject]! {
        switch (self) {
        case .Dictionary(let dictionary):
            return dictionary
        case .Array(_):
            return nil
        }
    }
    
}
