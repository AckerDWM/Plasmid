//
//  FeatureVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class FeatureVC: UITableViewController
{

  override func viewDidLoad()
  {
    super.viewDidLoad()

  }
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0
  }

  /*
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

    // Configure the cell...

    return cell
  }
  */

  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete
    {
      // Delete the row from the data source
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
  }

}
