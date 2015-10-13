//
//  DnaInput.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/13/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

extension UITextView
{
  func useDNAKeyboard()
  {
    self.inputView = DnaInput()
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dnaKeySelected:", name: "dnaKeySelected", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  func dnaKeySelected(notification: NSNotification)
  {
    let userInfo = notification.userInfo as! [String : String]
    let key = userInfo["key"]!
    switch key
    {
    case "<":
      if count(self.text) > 0
      {
        self.text = dropLast(self.text)
      }
    case "Done":
      if self.isFirstResponder()
      {
        self.resignFirstResponder()
      }
    default:
      self.text = self.text + key
    }
  }
  
  func orientationChanged()
  {
    if self.isFirstResponder()
    {
      let complete = self.resignFirstResponder()
      self.inputView = DnaInput()
      self.becomeFirstResponder()
    }
    else
    {
      self.inputView = DnaInput()
    }
  }
  
}

extension UISearchBar
{
  
  func useDNAKeyboard()
  {
    for view in self.subviews[0].subviews
    {
      if let textField = view as? UITextField
      {
        textField.inputView = DnaInput()
      }
    }
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "dnaKeySelected:", name: "dnaKeySelected", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }
  
  func dnaKeySelected(notification: NSNotification)
  {
    let userInfo = notification.userInfo as! [String : String]
    let key = userInfo["key"]!
    switch key
    {
    case "<":
      if count(self.text) > 0
      {
        self.text = dropLast(self.text)
      }
    case "Done":
      if self.isFirstResponder()
      {
        NSNotificationCenter.defaultCenter().postNotificationName("searchButtonClicked", object: nil)
        self.resignFirstResponder()
      }
    default:
      self.text = self.text + key
    }
  }
  
  func orientationChanged()
  {
    if self.isFirstResponder()
    {
      let complete = self.resignFirstResponder()
      for view in self.subviews[0].subviews
      {
        if let textField = view as? UITextField
        {
          textField.inputView = DnaInput()
        }
      }
      self.becomeFirstResponder()
    }
    else
    {
      for view in self.subviews[0].subviews
      {
        if let textField = view as? UITextField
        {
          textField.inputView = DnaInput()
        }
      }
    }
  }
}

class DnaInput: UIInputView
{
  var rect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60)
  
  override init(frame: CGRect, inputViewStyle: UIInputViewStyle)
  {
    super.init(frame: rect, inputViewStyle: inputViewStyle)
    addToolBar()
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  func keySelected(sender: UIBarButtonItem)
  {
    NSNotificationCenter.defaultCenter().postNotificationName("dnaKeySelected", object: nil, userInfo: ["key" : sender.title!])
  }
  
  func addToolBar()
  {
    let toolBar = UIToolbar(frame: rect)
    var items: [AnyObject] = []
    let keys = ["A", "T", "G", "C", "<"]
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    items.append(flexSpace)
    for i in 0...4
    {
      let button = UIBarButtonItem(title: keys[i], style: .Plain, target: self, action: "keySelected:")
      items.append(button)
      items.append(flexSpace)
    }
    var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("keySelected:"))
    items.append(done)
    toolBar.items = items
    self.addSubview(toolBar)
  }
  
}
