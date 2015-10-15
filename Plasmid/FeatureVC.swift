//
//  FeatureVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class FeatureVC: UIViewController, UITableViewDataSource, UITableViewDelegate,  UITextFieldDelegate
{
 
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var tableViewDistFromBottom: NSLayoutConstraint!
  
  var features = Global.activeSeqObject.features
  var tableValues: [(label: String?, color: CGFloat)] = []
  var selectedIndexPath = NSIndexPath()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "newHueSelected:", name: "hueChanged", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardAppeared:", name: UIKeyboardDidShowNotification, object: nil)
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
    self.tableViewDistFromBottom.constant = 0
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
          var hasLabel = false
          for (var ii = 0; ii < features[i].qualifiers.count; ii++)
          {
            if (features[i].qualifiers[ii].definition as NSString).containsString("label")
            {
              features[i].qualifiers[ii].content = label
              hasLabel = true
            }
          }
          if !hasLabel
          {
            let labelQualifier: (definition: String, content: String?) = (definition: "\"label\"", content: "\"\(label)\"")
            features[i].qualifiers.append(labelQualifier)
          }
        }
      }
    }
    Global.activeSeqObject.features = features
    Global.activeSeqObject = Global.activeSeqObject
  }
  
  // Scroll selected text field to visible
  
  // MARK : view resizing
  func keyboardAppeared(notification: NSNotification)
  {
    let frame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    self.tableViewDistFromBottom.constant = frame.height
    let timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "timedEvent", userInfo: nil, repeats: false)
  }
  
  func timedEvent()
  {
    self.tableView.scrollToRowAtIndexPath(self.selectedIndexPath, atScrollPosition: .Bottom, animated: true)
  }
  
  // MARK: - Table view data source

  func numberOfSectionsInTableView(tableView: UITableView) -> Int
  {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
  {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return features.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
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
    huePicker.row = indexPath.row
    huePicker.h = feature.color!
    
    return cell
  }

  // Override to support editing the table view.
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
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
  func textFieldShouldReturn(textField: UITextField) -> Bool
  {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(textField: UITextField)
  {
    if count(textField.text) > 0
    {
      let center = textField.center
      let inTable = self.tableView.convertPoint(center, fromView: textField.superview)
      let indexPath = self.tableView.indexPathForRowAtPoint(inTable)!
      self.tableValues[indexPath.row].label = textField.text
      self.tableViewDistFromBottom.constant = 0
    }
  }
  
  // doesn't really work for scrolling...s
  func textFieldDidBeginEditing(textField: UITextField)
  {
    let center = textField.center
    let inTable = self.tableView.convertPoint(center, fromView: textField.superview)
    let indexPath = self.tableView.indexPathForRowAtPoint(inTable)!
    self.selectedIndexPath = indexPath
  }
  
  func newHueSelected(notification: NSNotification)
  {
    if self.tableValues.count > 0
    {
      let userInfo = notification.userInfo as! [String : NSNumber]
      let newHue = userInfo["hue"] as! CGFloat
      let row = userInfo["row"] as! Int
      if row < self.tableValues.count
      {
        self.tableValues[row].color = newHue
        self.features[row].color = newHue
      }
    }
  }

}
