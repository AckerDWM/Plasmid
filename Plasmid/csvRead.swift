//
//  csvWrite.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/12/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

func csvRead(path: String) -> [[String]]
{
  let fileAsString = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
  if count(fileAsString) > 0
  {
    let lines = fileAsString.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    var splitLines = [[String]](count: lines.count, repeatedValue: [])
    for (var i = 0; i < lines.count; i++)
    {
      let split = lines[i].componentsSeparatedByString(",")
      splitLines[i] = split
    }
    return splitLines
  }
  else
  {
    return []
  }
}