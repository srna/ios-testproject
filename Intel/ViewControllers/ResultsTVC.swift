//
//  ResultsTVC.swift
//  Intel
//
//  Created by Tomas Srna on 10/08/16.
//  Copyright © 2016 Tomas Srna. All rights reserved.
//

import UIKit

class ResultsTVC: UITableViewController {
    
    var books: [Book]!

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath)

        cell.textLabel?.text = books[indexPath.row].title
        cell.detailTextLabel?.text = "\(books[indexPath.row].pageCount) pages"

        return cell
    }
}
