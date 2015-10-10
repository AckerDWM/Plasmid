//
//  File.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/7/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

class Global
{
  
  static var activeSeqObject = Seq()
  {
    willSet(newVal)
    {
      // generate new attributed string
      var newAttibuted = NSMutableAttributedString(string: newVal.sequence)
      for (var i = 0; i < newVal.features.count; i++)
      {
        var feature = newVal.features[i]
        // assign color
        let color = feature.color ?? {
          // assign a random feature color if one doesn't exist
          let newColor = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
          newVal.features[i].color = newColor
          let newQualifier: (definition: String, content: String?) = (definition: "\"PlasmidColor\"", content: "\"\(newColor)\"")
          newVal.features[i].qualifiers.append(newQualifier)
          return newColor
        }()
        // assign position
        for position in feature.positions
        {
          let start = position.start - 1
          let end = position.end ?? position.start
          let range = NSMakeRange(start, end - start)
          let color = UIColor(hue: color, saturation: 1, brightness: 1, alpha: 1)
          newAttibuted.addAttribute(NSBackgroundColorAttributeName, value: color, range: range)
        }
        // assign label
        let labelDefinitions = ["label", "gene", "allele", "note", "product", "function"]
        qualLabelLoop: for qualifier in feature.qualifiers
        {
          for definition in labelDefinitions
          {
            if (qualifier.definition as NSString).containsString(definition)
            {
              newVal.features[i].label = qualifier.content!
              break qualLabelLoop
            }
          }
        }
      }
      Global.seqAttributedString = newAttibuted
    }
  }
  
  static var seqAttributedString = NSAttributedString()
  {
    didSet(oldVal)
    {
      NSNotificationCenter.defaultCenter().postNotificationName("newAttributedString", object: nil)
    }
  }
  
  static var activeDBPath: DBPath?
  
  static var selectedText = String()
  
  static var selectedRange = NSRange()
  
}