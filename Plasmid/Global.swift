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
      for i in 0...newVal.features.count - 1
      {
        var feature = newVal.features[i]
        // assign a random feature color if one doesn't exist
        println(feature.color)
        let colorTouple = feature.color ??
        {
          var randomFloats = [CGFloat(), CGFloat(), CGFloat()]
          for ii in 0...2
          {
            let rand = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
            randomFloats[ii] = rand
          }
          let colorTouple: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) = (hue: randomFloats[0], saturation: randomFloats[1], brightness: randomFloats[2])
          newVal.features[i].color = colorTouple
          // add feature as a qualifier
          let newQualifier: (definition: String, content: String?) = (definition: "\"PlasmidColor\"", content: "\"\(colorTouple.hue),\(colorTouple.hue),\(colorTouple.hue)\"")
          newVal.features[i].qualifiers.append(newQualifier)
          return colorTouple
        }()
        for position in feature.positions
        {
          let start = position.start - 1
          let end = position.end ?? position.start
          let range = NSMakeRange(start, end - start)
          let color = UIColor(hue: colorTouple.hue, saturation: colorTouple.saturation, brightness: colorTouple.brightness, alpha: 1)
          newAttibuted.addAttribute(NSBackgroundColorAttributeName, value: color, range: range)
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
  
}