//
//  meltingTemperature.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/9/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

/// Calculates the melting temperature of a DNA string based on the characters [atgcATGC].
/// Calculation is based on the Wallace rule and is accurate for DNAs between 14 and 20 bases
func meltingTemperature(DNA: String) -> Int
{
  let uppercaseDNA = DNA.uppercaseString
  let ATRegex = NSRegularExpression(pattern: "[TA]", options: nil, error: nil)!
  let GCRegex = NSRegularExpression(pattern: "[GC]", options: nil, error: nil)!
  let range = NSMakeRange(0, count(DNA))
  let countAT = ATRegex.numberOfMatchesInString(uppercaseDNA, options: nil, range: range)
  let countGC = GCRegex.numberOfMatchesInString(uppercaseDNA, options: nil, range: range)
  return 2 * countAT + 4 * countGC
}