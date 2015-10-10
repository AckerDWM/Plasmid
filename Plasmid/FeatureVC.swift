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
  
  var features = Global.activeSeqObject.features
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
    features = Global.activeSeqObject.features
  }
  
  // problem... cellForRowAtIndexPath only finds visible cells, so this crashes
  override func viewWillDisappear(animated: Bool)
  {
    for (var i = 0; i < features.count; i++)
    {
      let indexPath = NSIndexPath(forRow: i, inSection: 0)
      let cell = self.tableView.cellForRowAtIndexPath(indexPath)
      let huePicker = cell?.viewWithTag(3) as! HuePicker
      features[i].color = huePicker.h
      for (var ii = 0; ii < features[i].qualifiers.count; ii++)
      {
        if features[i].qualifiers[ii].definition == "\"PlasmidColor\""
        {
          features[i].qualifiers[ii].content = "\"\(features[i].color)\""
        }
      }
      let labelTextField = cell?.viewWithTag(2) as! UITextField
      features[i].label = labelTextField.text!
      if count(features[i].label!) > 0
      {
        for (var ii = 0; ii < features[i].qualifiers.count; ii++)
        {
          var hasLabel = false
          if (features[i].qualifiers[ii].definition as NSString).containsString("label")
          {
            features[i].qualifiers[ii].content = features[i].label
            hasLabel = true
          }
          if !hasLabel
          {
            let labelQualifier: (definition: String, content: String?) = (definition: "\"label\"", content: "\"\(features[i].label)\"")
            features[i].qualifiers.append(labelQualifier)
          }
        }
      }
    }
    Global.activeSeqObject.features = features
    Global.activeSeqObject = Global.activeSeqObject
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return features.count
  }


  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

    // Configure the cell...
    let feature = features[indexPath.row]
    let keyLabel = cell.viewWithTag(1) as! UILabel
    keyLabel.text = feature.key
    let labelTextField = cell.viewWithTag(2) as! UITextField
    if let label = feature.label
    {
      labelTextField.text = feature.label
    }
    let huePicker = cell.viewWithTag(3) as! HuePicker
    huePicker.h = feature.color!
    
    return cell
  }

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
