//
//  translateDNA.swift
//  Plasmid
//
//  Created by Daniel Acker on 10/9/15.
//  Copyright (c) 2015 Daniel Acker. All rights reserved.
//

import Foundation

/// Translates a DNA sequence including only characters in the set [atgcATGC]
func translateDNA(DNA: String) -> String
{
  let uppercaseDNA = DNA.uppercaseString
  let length = Int(floor(Double(count(DNA)) / 3.0))
  var codonArray = Array(count: length, repeatedValue: String())
  codonLoop: for (var i = 0; i < length; i++)
  {
    let range = NSMakeRange(i * 3, 3)
    let codon = (uppercaseDNA as NSString).substringWithRange(range)
    switch codon
    {
    case "GCT", "GCC", "GCA", "GCG":
      codonArray[i] = "A"
    case "CGT", "CGC", "CGA", "CGG", "AGA", "AGG":
      codonArray[i] = "R"
    case "AAT", "AAC":
      codonArray[i] = "N"
    case "GAT", "GAC":
      codonArray[i] = "D"
    case "TGT", "TGC":
      codonArray[i] = "C"
    case "CAA", "CAG":
      codonArray[i] = "Q"
    case "GAA", "GAG":
      codonArray[i] = "E"
    case "GGT", "GGC", "GGA", "GGG":
      codonArray[i] = "G"
    case "CAT", "CAC":
      codonArray[i] = "H"
    case "ATT", "ATC", "ATA":
      codonArray[i] = "I"
    case "ATG":
      codonArray[i] = "M"
    case "TTA", "TTG", "CTT", "CTC", "CTA", "CTG":
      codonArray[i] = "L"
    case "AAA", "AAG":
      codonArray[i] = "K"
    case "TTT", "TTC":
      codonArray[i] = "F"
    case "CCT", "CCC", "CCA", "CCG":
      codonArray[i] = "P"
    case "TCT", "TCC", "TCA", "TCG", "AGT", "AGC":
      codonArray[i] = "S"
    case "ACT", "ACC", "ACA", "ACG":
      codonArray[i] = "T"
    case "TGG":
      codonArray[i] = "W"
    case "TAT", "TAC":
      codonArray[i] = "Y"
    case "GTT", "GTC", "GTA", "GTG":
      codonArray[i] = "V"
    default:
      codonArray[i] = "*"
      break codonLoop
    }
  }
  return ("").join(codonArray)
}