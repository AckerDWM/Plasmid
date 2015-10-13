//
//  dnaKeyboardExtension.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/13/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

extension UITextView
{
  
  func dnaKeySelected(sender: UIBarButtonItem)
  {
    println(sender.title!)
  }
  
  func doneButtonAction()
  {
    self.resignFirstResponder()
  }
  
  func addDNAAccessory()
  {
    let dnaAccessory = UIToolbar(frame: CGRect()) // accurately specify frame later
    dnaAccessory.sizeToFit()
    var items: [AnyObject] = []
    let keys = ["A", "T", "G", "C"]
    let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    items.append(flexSpace)
    for i in 0...3
    {
      let button = UIBarButtonItem(title: keys[i], style: .Plain, target: self, action: "dnaKeySelected:")
      items.append(button)
      items.append(flexSpace)
    }
    var done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: Selector("doneButtonAction"))
    items.append(done)
    dnaAccessory.items = items
    self.inputAccessoryView = dnaAccessory
  }
  
}