//
//  FileTableVCTableViewController.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/7/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class FileTableVCTableViewController: UITableViewController
{
  
  var files: [DBPath] = []
  {
    didSet(oldVal)
    {
      self.tableView.reloadData()
    }
  }

  override func viewDidLoad()
  {
    super.viewDidLoad()

    self.clearsSelectionOnViewWillAppear = false
  }
  
  override func viewWillAppear(animated: Bool) {
    // load list of usable files
    self.loadDropboxFileList()
  }

  // MARK: - Table view delegate
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let path = files[indexPath.row]
    DropboxManager.openFile(path) {
      contents in
      Global.activeSeqObject = GenbankParser.parseGenbank(contents)
      NSNotificationCenter.defaultCenter().postNotificationName("newSeqObject", object: nil)
    }
  }
  
  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    return self.files.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

    // Configure the cell...
    cell.textLabel?.text = self.files[indexPath.row].stringValue().lastPathComponent
    
    return cell
  }

  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete
    {
      // Delete the row from the data source
      self.tableView.beginUpdates()
      self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      let path = self.files[indexPath.row]
      self.files.removeAtIndex(indexPath.row)
      DropboxManager.deleteFile(path)
      { success in
        if success
        {
          self.loadDropboxFileList()
        }
      }
      self.tableView.endUpdates()
    }
  }
  
  func loadDropboxFileList()
  {
    DropboxManager.listFiles() {
      files in
      var newFileList: [DBPath] = []
      for file in files
      {
        let string = file.path.stringValue()
        if string.hasSuffix(".gb") || string.hasSuffix(".fasta")
        {
          newFileList.append(file.path)
        }
      }
      self.files = newFileList
    }
  }

}
