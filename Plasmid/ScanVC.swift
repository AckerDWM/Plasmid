//
//  ScanVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/11/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class ScanVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
  
  @IBOutlet weak var tableViewOut: UITableView!
  
  typealias feature = (label: String, key: String, sequence: String)
  
  var userDatabases: [DBPath] = []
  {
    didSet(oldVal)
    {
      self.tableViewOut.reloadData()
    }
  }
  
  let defaultDatabases = [
    "Default_Features",
    "Default_Terminators",
    "Default_Promoters",
    "Default_Genes",
    "Default_Origins",
    "Default_Regulatory_Elements"]
  
  var userSelections: [Bool] = []
  
  var defaultSelections = [false, false, false, false, false, false]
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.navigationController?.navigationBarHidden = false
    self.tableViewOut.allowsMultipleSelection = true
  }
  
  override func viewWillAppear(animated: Bool) {
    self.loadUserDatabases()
  }
  
  func loadUserDatabases()
  {
    DropboxManager.listFiles()
    {
      results in
      var databases: [DBPath] = []
      for file in results
      {
        let path = file.path
        if path.stringValue().pathExtension == "csv"
        {
          databases.append(path)
        }
      }
      self.userDatabases = databases
      self.userSelections = [Bool](count: databases.count, repeatedValue: false)
    }
  }
  
  // MARK : Table view delegate
  func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath)
  {
    // show feature database in collection view
    // ...
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
  {
    // set databases as selected
    if indexPath.section == 0
    {
      self.defaultSelections[indexPath.row] = true
    }
    else
    {
      self.userSelections[indexPath.row] = true
    }
  }
  
  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath)
  {
    // set databases as unselected
    if indexPath.section == 0
    {
      self.defaultSelections[indexPath.row] = false
    }
    else
    {
      self.userSelections[indexPath.row] = false
    }
  }
  
  // MARK : Table view data source
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    if section == 0
    {
      return defaultDatabases.count
    }
    else
    {
      return userDatabases.count
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    if indexPath.section == 0
    {
      cell.textLabel?.text = defaultDatabases[indexPath.row].stringByDeletingPathExtension
    }
    else
    {
      cell.textLabel?.text = userDatabases[indexPath.row].stringValue().stringByDeletingPathExtension
    }
    
    return cell
  }
  
  // read databases into lists of features
  // !!! Untested for user databases!!!
  func loadSelections(defaultSelections: [Bool], userSelections: [Bool])
  {
    // annotate from selected default feature databases
    var newFeatures: [feature] = []
    for (var i = 0; i < defaultSelections.count; i++)
    {
      if defaultSelections[i] == true
      {
        // read into csv
        let resource = self.defaultDatabases[i]
        let path = NSBundle.mainBundle().pathForResource(resource, ofType: "csv")!
        let csv = csvRead(path)
        // identify features
        for row in csv
        {
          let newFeature: feature = (label: row[0], key: row[1], sequence: row[2])
          newFeatures.append(newFeature)
        }
      }
    }
    // annotate default features
    annotateFeatures(newFeatures)
    // annotate from selected user feature databases
    for (var i = 0; i < userSelections.count; i++)
    {
      if userSelections[i]
      {
        let dbPath = self.userDatabases[i]
        DropboxManager.openFile(dbPath)
        { // perform user database annotation on completion
          fileString in
          var newFeatures: [feature] = []
          // read into csv
          var csv: [[String]] = []
          if count(fileString) > 0
          {
            let lines = fileString.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
            var splitLines = [[String]](count: lines.count, repeatedValue: [])
            for (var i = 0; i < lines.count; i++)
            {
              let split = lines[i].componentsSeparatedByString(",")
              splitLines[i] = split
            }
            csv = splitLines
          }
          // identify features
          for row in csv
          {
            let newFeature: feature = (label: row[0], key: row[1], sequence: row[2])
            newFeatures.append(newFeature)
          }
          // annotate user features
          annotateFeatures(newFeatures)
        }
      }
    }
  }
  
  @IBAction func scanSelectedBtn(sender: AnyObject)
  {
    // scan using selected databases
    self.loadSelections(self.defaultSelections, userSelections: self.userSelections)
  }
  
  @IBAction func scanAllBtn(sender: AnyObject)
  {
    // scan using all loaded databases
    let defaultSelections = [Bool](count: self.defaultSelections.count, repeatedValue: true)
    let userSelections = [Bool](count: self.userSelections.count, repeatedValue: true)
    self.loadSelections(defaultSelections, userSelections: userSelections)
  }
}