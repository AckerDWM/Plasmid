//
//  percentGC.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/9/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

/// Calculates the GC content of a DNA string. Uses only the characters [atgcATGC]
func percentGC(DNA: String) -> Double
{
  let GCRegex = NSRegularExpression(pattern: "[gcGC]", options: nil, error: nil)!
  let countGC = GCRegex.numberOfMatchesInString(DNA, options: nil, range: NSMakeRange(0, count(DNA)))
  return (Double(countGC) / Double(count(DNA))) * 100
}