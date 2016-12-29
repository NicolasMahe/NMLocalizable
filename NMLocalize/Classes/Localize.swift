//
//  Localizable.swift
//  NMLocalizable
//
//  Created by Nicolas Mahé on 22/06/16.
//  Copyright © 2016 Nicolas Mahé. All rights reserved.
//

import UIKit

/**
 Shortcut function for NSLocalizedString
 */
public func L(_ string: String, bundle: Bundle = Bundle.main) -> String {
  let localized = NSLocalizedString(string, bundle: bundle, comment: "")
  return localized
}

/**
 Shortcut function for NSLocalizedString with arguments
 */
public func L(_ string: String, bundle: Bundle = Bundle.main, _ args: CVarArg...) -> String {
  let localized = NSLocalizedString(string, bundle: bundle, comment: "")
  return String(format: localized, arguments: args)
}
public func L(_ string: String, bundle: Bundle = Bundle.main, arguments: [CVarArg]) -> String {
  let localized = NSLocalizedString(string, bundle: bundle, comment: "")
  return String(format: localized, arguments: arguments)
}

open class Localize {
  
  /**
   Get the first preferred language of the device
   */
  open class var preferredLanguage: String {
    let preferredLanguage = NSLocale.preferredLanguages
      .flatMap { (l: String) -> String? in
        return l.components(separatedBy: "-").first
      }
      .first
    
    return preferredLanguage!
  }
  
}
