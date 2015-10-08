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