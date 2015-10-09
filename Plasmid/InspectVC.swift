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
    text += "Length:\t\(length)bp"
    let Td = meltingTemperature(Global.selectedText)
    text += "\n\nTd:\t\(Td)°C"
    let GCContent = percentGC(Global.selectedText)
    text += "\n\nGC content:\t\(GCContent)%"
    
    // Find included features
    text += "\n\nFeatures:"
    for feature in Global.activeSeqObject.features
    {
      for position in feature.positions
      {
        if position.start > Global.selectedRange.location
        {
          if position.start < Global.selectedRange.location + Global.selectedRange.length
          {
            let end = position.end ?? position.start + 1
            if end <= Global.selectedRange.location + Global.selectedRange.length
            {
              text += "\n\n\t \(feature.key)"
              if let label = feature.label
              {
                text += "\n\t \(feature.label)"
              }
            }
          }
        }
      }
    }
    
    self.textView.text = text
  }
  
}