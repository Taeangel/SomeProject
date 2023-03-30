//
//  Array.swift
//  TodoVipApp
//
//  Created by song on 2023/03/31.
//

import Foundation

extension Array where Element: Hashable {
  func removeDuplicates() -> [Element] {
    var addedDict = [Element: Bool]()
    return filter ({ addedDict.updateValue(true, forKey: $0) == nil })
  }
}
