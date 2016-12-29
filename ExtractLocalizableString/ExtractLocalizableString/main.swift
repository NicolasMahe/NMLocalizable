//
//  main.swift
//  ExtractLocalizableString
//
//  Created by Nicolas Mahé on 03/10/2016.
//  Copyright © 2016 Nicolas Mahé. All rights reserved.
//

import Foundation

//----------------------------------------------------------------------------
// MARK: - Options
//----------------------------------------------------------------------------

let extensionOfFiles = ".swift"
let regexPattern = "L\\(\"(.+?)\""

let regexPatternStringFile = "\"(.+)\" = \"(.+)\";"
let stringFilePattern = "\"%@\" = \"%@\";"

var forceDefaultValue: String? = nil

//----------------------------------------------------------------------------
// MARK: - Console arguments
//----------------------------------------------------------------------------

guard CommandLine.arguments.count > 2
  else {
    print("no enough argument")
    exit(1)
}

let path = CommandLine.arguments[1]
let stringFilePath = CommandLine.arguments[2]
if CommandLine.arguments.count > 3 {
  forceDefaultValue = CommandLine.arguments[3]
}

print("Will analyze folder " + path)
print("Will export localizable string in " + stringFilePath)
print("")

//----------------------------------------------------------------------------
// MARK: - Helpers
//----------------------------------------------------------------------------

func convert(range: NSRange, string: String) -> Range<String.Index> {
  let start = string.index(string.startIndex, offsetBy: range.location)
  let end = string.index(string.startIndex, offsetBy: range.location + range.length)
  let range = start..<end
  return range
}

extension Array where Element: LocalizableString {
  
  func get(_ m: LocalizableString) -> LocalizableString? {
    return self.filter { (e: Element) -> Bool in
      return m.key == e.key
    }
    .first
  }
  
  func contains(_ m: LocalizableString) -> Bool {
    return self.contains { (e: Element) -> Bool in
      return m.key == e.key
    }
  }
  
}

class LocalizableString {
  
  let key: String
  let valueOpt: String?
  
  init(
    key: String,
    value: String?
  ) {
    self.key = key
    self.valueOpt = value
  }
  
  var value: String {
    return self.valueOpt ?? (forceDefaultValue ?? self.key)
  }
  
  class func sort(e1: LocalizableString, e2: LocalizableString) -> Bool {
    return e1.key.localizedCaseInsensitiveCompare(e2.key) == .orderedAscending
  }

}

//----------------------------------------------------------------------------
// MARK: - Constant
//----------------------------------------------------------------------------

let regex = try! NSRegularExpression(pattern: regexPattern, options: .caseInsensitive)
let regexStringFile = try! NSRegularExpression(pattern: regexPatternStringFile, options: .caseInsensitive)
let fileManager = FileManager.default
var existingLocalizableStrings = [LocalizableString]()
var newLocalizableStrings = [LocalizableString]()
var cleanlocalizableStrings = [LocalizableString]()

//----------------------------------------------------------------------------
// MARK: - Procedure
//----------------------------------------------------------------------------

//
//#1 Add existing localizable string
//
do {
  let contentOfStringFile = try String(contentsOfFile: stringFilePath)
  
  //Regex
  let matches = regexStringFile.matches(in: contentOfStringFile, options: [], range: NSMakeRange(0, contentOfStringFile.characters.count))
  
  //LocalizableStrings
  matches.forEach { (match: NSTextCheckingResult) in
    let range = convert(range: match.range, string: contentOfStringFile)
    let matchContent = contentOfStringFile.substring(with: range)
    
    let key = regex.replacementString(for: match, in: contentOfStringFile, offset: 0, template: "$1")
    let value = regex.replacementString(for: match, in: contentOfStringFile, offset: 0, template: "$2")
    
    //add to array
    existingLocalizableStrings.append(
      LocalizableString(
        key: key,
        value: value
      )
    )
  }
}
catch {
  print("error while oponing string file") //@todo: this error appear also when the file doesn't exist
}


//
//#2 Extract localizable string from project files
//
//Get all file of path
guard var allFiles = fileManager.subpaths(atPath: path)
  else {
    print("error with the path")
    exit(1)
}

//Keep only file with the right extension
let swiftFiles = allFiles
  .filter { (file: String) -> Bool in
    return file.contains(extensionOfFiles)
  }
  .map { (file: String) -> String in
  return path + file
}

//Extract all string from all the files
swiftFiles.forEach { (file: String) in
  do {
    //Get content of file
    let contentOfFile = try String(contentsOfFile: file)
    
    //Regex
    let matches = regex.matches(in: contentOfFile, options: [], range: NSMakeRange(0, contentOfFile.characters.count))
    
    //LocalizableStrings
    matches.forEach { (match: NSTextCheckingResult) in
      let range = convert(range: match.range, string: contentOfFile)
      let matchContent = contentOfFile.substring(with: range)
      let matchContentCleaned = regex.replacementString(for: match, in: contentOfFile, offset: 0, template: "$1")
      
      //add to array
      newLocalizableStrings.append(
        LocalizableString(
          key: matchContentCleaned,
          value: nil
        )
      )
    }
  }
  catch {
    dump(error)
    print("error with file: " + file)
  }
}

//
//#3 Remove duplicates localizable string from newLocalizableStrings
//
var newLocalizableStringsFiltered = [LocalizableString]()
newLocalizableStrings.forEach { (match: LocalizableString) in
  if newLocalizableStringsFiltered.contains(match) == false {
    newLocalizableStringsFiltered.append(match)
  }
}
newLocalizableStrings = newLocalizableStringsFiltered



var numberOfKeepedLocalizable = 0
var numberOfAddedLocalizable = 0

//
//#3 Merge existingLocalizableStrings and newLocalizableStrings
//   Keep only string that are in newLocalizableStrings
//
newLocalizableStrings.forEach { (new: LocalizableString) in
  if let old = existingLocalizableStrings.get(new) {
    cleanlocalizableStrings.append(old)
    numberOfKeepedLocalizable += 1
  }
  else {
    cleanlocalizableStrings.append(new)
    numberOfAddedLocalizable += 1
  }
}


let numberOfRemovedLocalizable = existingLocalizableStrings.count - numberOfKeepedLocalizable

//Sort
cleanlocalizableStrings.sort(by: LocalizableString.sort)

//Put all match in the string file
let stringFileNewContent = cleanlocalizableStrings.reduce("") { (r: String, match: LocalizableString) -> String in
  return r + "\n\n" + String(format: stringFilePattern, match.key, match.value)
}

//
//#4 Save localizable file
//
try! stringFileNewContent.write(toFile: stringFilePath, atomically: true, encoding: String.Encoding.utf8)



print("Done. Keep " + numberOfKeepedLocalizable.description + ", add " + numberOfAddedLocalizable.description + ", remove " + numberOfRemovedLocalizable.description)
