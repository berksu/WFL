//
//  NSDictionaryExtension.swift
//  WFL
//
//  Created by Berksu Kısmet on 22.12.2021.
//

import Foundation

extension NSDictionary {
  var swiftDictionary: [String : AnyObject] {
    var swiftDictionary: [String : AnyObject] = [:]
    let keys = self.allKeys.flatMap { $0 as? String }
    for key in keys {
      let keyValue = self.value(forKey: key) as AnyObject
      swiftDictionary[key] = keyValue
    }
    return swiftDictionary
  }
}
