//
//  FeatureVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class FeatureVC: UITableViewController, UITextFieldDelegate
{
  
  var features = Global.activeSeqObject.features
  var tableValues: [(label: String?, color: CGFloat)] = []
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "newHueSelected:", name: "hueChanged", object: nil)
  }
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
    self.features = Global.activeSeqObject.features
    for feature in features
    {
      let newValues: (label: String?, color: CGFloat) = (label: feature.label, color: feature.color!)
      self.tableValues.append(newValues)
    }
  }
  
  override func viewWillDisappear(animated: Bool)
  {
    for (var i = 0; i < count(features); i++)
    {
      let color = tableValues[i].color
      // assign colors
      features[i].color = color
      for (var ii = 0; ii < features[i].qualifiers.count; ii++)
      {
        if features[i].qualifiers[ii].definition == "\"PlasmidColor\""
        {
          features[i].qualifiers[ii].content = "\"\(color)\""
        }
      }
      // assign labels
      if let label = tableValues[i].label
      {
        if count(label) > 0
        {
          features[i].label = label
          for (var ii = 0; ii < features[i].qualifiers.count; ii++)
          {
            var hasLabel = false
            if (features[i].qualifiers[ii].definition as NSString).containsString("label")
            {
              features[i].qualifiers[ii].content = label
              hasLabel = true
            }
            if !hasLabel
            {
              let labelQualifier: (definition: String, content: String?) = (definition: "\"label\"", content: "\"\(label)\"")
              features[i].qualifiers.append(labelQualifier)
            }
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
    labelTextField.delegate = self
    if let label = feature.label
    {
      labelTextField.text = feature.label
    }
    let huePicker = cell.viewWithTag(3) as! HuePicker
    huePicker.h = feature.color!
    huePicker.row = indexPath.row
    
    return cell
  }

  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
  {
    if editingStyle == .Delete
    {
      // Delete the row from the data source
      tableView.beginUpdates()
      features.removeAtIndex(indexPath.row)
      tableValues.removeAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      tableView.endUpdates()
    }
  }
  
  // MARK : Text field delegate
  func textFieldDidEndEditing(textField: UITextField)
  {
    if count(textField.text) > 0
    {
      let center = textField.center
      let inTable = tableView.convertPoint(center, fromView: textField.superview)
      let indexPath = tableView.indexPathForRowAtPoint(inTable)!
      self.tableValues[indexPath.row].label = textField.text
    }
  }
  
  func newHueSelected(notification: NSNotification)
  {
    if self.tableValues.count > 0
    {
      let userInfo = notification.userInfo as! [String : NSNumber]
      let newHue = userInfo["hue"] as! CGFloat
      let row = userInfo["row"] as! Int
      self.tableValues[row].color = newHue
    }
  }

}
