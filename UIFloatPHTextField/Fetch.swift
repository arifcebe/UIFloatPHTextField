//
//  Fetch.swift
//
//  Created by Salim Wijaya
//  Copyright © 2017. All rights reserved.
//

import Foundation

class Fetch<T: DataConvertible> {
    public typealias Succeeder = (T) -> ()
    
    public typealias Failer = (Error?) -> ()
    
    fileprivate var onSuccess : Succeeder?
    
    fileprivate var onFailure : Failer?
    
    var session : URLSession { return URLSession.shared }
    
    private var task: URLSessionDataTask?
    
    var cancelled: Bool = false
    
    let URL: URL!
    init(URL: URL) {
        self.URL = URL
    }
    
    func request(failure fail: @escaping ((Error?) -> ()), success succeed: @escaping (T.Result) -> ()){
        self.task = session.dataTask(with: self.URL, completionHandler: {(data, response, error) in
            self.onReceive(data: data, response: response, error: error, failure: fail, success: succeed)
        })
        self.task?.resume()
    }
    
    func cancel(){
        self.task?.cancel()
        self.cancelled = true
    }
    
    fileprivate func onReceive(data: Data!, response: URLResponse!, error: Error!, failure fail: @escaping ((Error?) -> ()), success succeed: @escaping (T.Result) -> ()) {
        if cancelled { return }
        
        
        if let error = error {
            if ((error as NSError).domain == NSURLErrorDomain && (error as NSError).code == NSURLErrorCancelled) { return }
            
            DispatchQueue.main.async(execute: { fail(error) })
            return
        }
        
        guard let value = T.convertFromData(data) else {
//            let localizedFormat = NSLocalizedString("Failed to convert value from data at URL %@", comment: "Error description")
//            let description = String(format:localizedFormat, (self.URL.url?.absoluteString)!)
//            print(description)
//            DispatchQueue.main.async(execute: { fail(error) })
//            self.failWithCode(.invalidData, localizedDescription: description, failure: fail)
            return
        }
        
        DispatchQueue.main.async { succeed(value) }
    }
}
