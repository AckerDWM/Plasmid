//
//  parseFasta.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/15/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

func parseFasta(contents: String) -> Seq
{
  let lines = contents.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
  var crudeSequence = String()
  for line in lines
  {
    if !line.hasPrefix(";") && !line.hasPrefix(">")
    {
      crudeSequence += line
    }
  }
  let seqRegex = NSRegularExpression(pattern: "[ATGC]+", options: .CaseInsensitive, error: nil)!
  let matches = seqRegex.matchesInString(crudeSequence, options: nil, range: NSMakeRange(0, count(crudeSequence)))
  var cleanedSequence = String()
  for match in matches
  {
    cleanedSequence += (crudeSequence as NSString).substringWithRange(match.range)
  }
  cleanedSequence = cleanedSequence.uppercaseString
  
  let newSeq = Seq()
  newSeq.sequence = cleanedSequence
  
  return newSeq
}