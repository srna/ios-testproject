//
//  SearchTVC.swift
//  Intel
//
//  Created by Tomas Srna on 09/08/16.
//  Copyright © 2016 Tomas Srna. All rights reserved.
//

import UIKit

class SearchTVC: UITableViewController {

    private func reset() {
        bookTitleTF.text = ""
        loadingAI.stopAnimating()
    }
    
    var books: [Book]!
    var searchTerm: String!
    
    // MARK: Outlets
    @IBOutlet weak var bookTitleTF: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var loadingAI: UIActivityIndicatorView!
    
    // MARK: Actions
    @IBAction func searchAction(sender: UIButton) {
        if let searchTerm = bookTitleTF.text where searchTerm != "" {
            loadingAI.startAnimating()
            BookService.sharedService.search(searchTerm) { (books, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    } else if let books = books {
                        self.books = books
                        self.searchTerm = searchTerm
                        self.performSegueWithIdentifier("ShowResultsSegue", sender: sender)
                    }
                    self.reset()
                }
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Please enter book title", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { (action) in
                self.bookTitleTF.becomeFirstResponder()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowResultsSegue" {
            if let resultsTVC = segue.destinationViewController as? ResultsTVC {
                resultsTVC.title = searchTerm
                resultsTVC.books = books
            }
        }
    }

}
