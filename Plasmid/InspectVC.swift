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
    if length <= 14 || length >= 20
    {
      text += "\n\tMelting temperature calculations based" +
               "\n\ton the Wallace Rule may be inaccurate" +
               "\n\tfor sequence of >20 or <14 base pairs"
    }
    let GCContent = percentGC(Global.selectedText)
    let rounded = Double(round(1000*GCContent)/1000)
    text += "\n\nGC content:\t\(rounded)%"
    
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
                text += "\n\t\t \(label)"
              }
            }
          }
        }
      }
    }
    
    self.textView.text = text
  }
  
}