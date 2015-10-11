//
//  AnnotateVC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/8/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import UIKit

class AnnotateVC: UIViewController
{

  @IBOutlet weak var keyBtnOut: UIButton!
  @IBOutlet weak var huePicker: HuePicker!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  let newFeature = Seq.Feature()
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeKey:", name: "keySelected", object: nil)
  }
  
  override func viewWillAppear(animated: Bool)
  {
    self.navigationController?.navigationBarHidden = false
    self.textView.text = Global.selectedText
    self.textField.text = String()
  }
  
  func changeKey(notification: NSNotification)
  {
    let userInfo = notification.userInfo as! [String : String]
    let newKey = userInfo["key"]
    self.keyBtnOut.setTitle(newKey, forState: .Normal)
  }
  
  @IBAction func addBtn(sender: AnyObject)
  {
    if count(self.textView.text) > 0
    {
      // assign key
      newFeature.key = self.keyBtnOut.currentTitle!
      // assign color
      newFeature.color = self.huePicker.h
      // create qualifier for color
      let colorQualifier: (definition: String, content: String?) = (definition: "\"PlasmidColor\"", content: "\"\(newFeature.color!)\"")
      newFeature.qualifiers.append(colorQualifier)
      // assign label
      if count(self.textField.text) > 0
      {
        newFeature.label = self.textField.text
        // create qualifier for label
        let labelQualifier: (definition: String, content: String?) = (definition: "\"label\"", content: "\"\(newFeature.label!)\"")
        newFeature.qualifiers.append(labelQualifier)
      }
      // assign positions
      let sequence = self.textView.text
      let sequenceRegex = NSRegularExpression(pattern: sequence, options: .CaseInsensitive, error: nil)!
      let matches = sequenceRegex.matchesInString(Global.activeSeqObject.sequence, options: nil, range: NSMakeRange(0, count(Global.activeSeqObject.sequence)))
      for match in matches
      {
        let range = match.range
        let start = range.location + 1
        var end: Int? = range.location + range.length
        var delimiter: String? = ".."
        if end! == start
        {
          end = nil
          delimiter = nil
        }
        let position: (start: Int, end: Int?, delimiter: String?, onCodingSequence: Bool) = (start: start, end: end, delimiter: delimiter, onCodingSequence: true)
        newFeature.positions.append(position)
      }
      if newFeature.positions.count > 0
      {
        var featureAlreadyExists = false
        featureComparison: for feature in Global.activeSeqObject.features
        {
          if feature.key == newFeature.key && feature.label == newFeature.label
          {
            featureAlreadyExists = true
            break featureComparison
          }
        }
        if featureAlreadyExists == false
        {
          Global.activeSeqObject.features.append(newFeature)
          Global.activeSeqObject = Global.activeSeqObject
          self.navigationController!.popViewControllerAnimated(true)
        }
      }
    }
  }

}
