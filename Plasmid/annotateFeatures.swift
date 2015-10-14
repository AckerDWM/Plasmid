//
//  annotateFeatures.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/12/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

func annotateFeatures(features: [(label: String, key: String, sequence: String)])
{
  var newFeatures: [Seq.Feature] = []
  for feature in features
  {
    let newFeature = Seq.Feature()
    newFeature.key = feature.key
    newFeature.label = feature.label
    let labelQualifier: (definition: String, content: String?) = (definition: "\"label\"", content: "\"\(newFeature.label!)\"")
    newFeature.qualifiers.append(labelQualifier)
    newFeature.color = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
    let colorQualifier: (definition: String, content: String?) = (definition: "\"PlasmidColor\"", content: "\"\(newFeature.color!)\"")
    newFeature.qualifiers.append(colorQualifier)
    let sequence = feature.sequence
    // assign positions
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
    if matches.count > 1
    {
      newFeature.joinType = "order"
    }
    if newFeature.positions.count > 0
    {
      // broken ...
      var featureAlreadyExists = false
      featureComparison: for feature in Global.activeSeqObject.features
      {
        println(feature.key)
        println(newFeature.key)
        println(feature.label)
        println(newFeature.label)
        if feature.key == newFeature.key && feature.label == "\"\(newFeature.label!)\""
        {
          featureAlreadyExists = true
          println("feature exists")
          break featureComparison
        }
      }
      if featureAlreadyExists == false
      {
        println("feature does not exists")
        newFeatures.append(newFeature)
      }
    }
  }
  Global.activeSeqObject.features.extend(newFeatures)
  Global.activeSeqObject = Global.activeSeqObject
}