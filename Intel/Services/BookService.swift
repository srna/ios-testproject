//
//  BookService.swift
//  Intel
//
//  Created by Tomas Srna on 09/08/16.
//  Copyright © 2016 Tomas Srna. All rights reserved.
//

import Foundation

class BookService {
    static let sharedService = BookService()
    
    private let baseURL = "https://www.googleapis.com/books/v1"
    
    func search(query: String, completionHandler: (books: [Book]?, error: NSError?) -> Void) {
        request(query) { (data, error) in
            do {
                if let data = data {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    if let items = json["items"] as? [[String:AnyObject]] {
                        completionHandler(books: items.flatMap(self.parseItem), error: nil)
                    }
                } else if let error = error {
                    throw error
                } else {
                    throw NSError(domain: "sk.srna.Intel", code: 100, userInfo: [NSLocalizedDescriptionKey: "Unknown Error"])
                }
                
            } catch let error as NSError {
                completionHandler(books: nil, error: error)
            }
        }
    }
    
    private func parseItem(item: [String:AnyObject]) -> Book? {
        if let volumeInfo = item["volumeInfo"] as? [String:AnyObject], title = volumeInfo["title"] as? String, pageCount = volumeInfo["pageCount"] as? UInt {
            return Book(title: title, pageCount: pageCount)
        }
        return nil
    }
    
    private func request(query: String, completionHandler: (data: NSData?, error: NSError?) -> Void) {
        if let encodedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()), url = NSURL(string: "\(baseURL)/volumes?q=\(encodedQuery)") {
            NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                completionHandler(data: data, error: error)
            }.resume()
        } else {
            completionHandler(data: nil, error: NSError(domain: "sk.srna.Intel", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid query"]))
        }
    }
}
