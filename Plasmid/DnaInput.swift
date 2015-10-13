//
//  DnaInput.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/13/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class DnaInput: UIInputView
{

  var rect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60)
  
  override init(frame: CGRect, inputViewStyle: UIInputViewStyle)
  {
    super.init(frame: rect, inputViewStyle: inputViewStyle)
    addDNAAccessory()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged", name: UIDeviceOrientationDidChangeNotification, object: nil)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func orientationChanged()
  {
    self.rect = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 60)
    self.setNeedsDisplay()
    // doesn't work...
  }

  func dnaKeySelected(sender: UIBarButtonItem)
  {
    println(sender.title!)
  }
  
  func doneButtonAction()
  {
    //self.inputViewStyle
  }
  
  func addDNAAccessory()
  {
    let dnaAccessory = UIToolbar(frame: rect)
    //dnaAccessory.sizeToFit()
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
    self.addSubview(dnaAccessory)
  }
  
}
