//
//  InspectVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

class InspectVC: UIViewController
{
  
  @IBOutlet weak var textView: UITextView!
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
    self.updateTextViewWithInspectableProperties()
  }
  
  func updateTextViewWithInspectableProperties()
  {
    var text = String()
    let length = count(Global.selectedText)
    text += "Length = \(length) bp"
    let Td = meltingTemperature(Global.selectedText)
    text += "\n\nTd = \(Td) °C"
    let GCContent = percentGC(Global.selectedText)
    text += "\n\nGC content = \(GCContent) %"
    
    // Find included features
    // ...
    
    self.textView.text = text
  }
  
}