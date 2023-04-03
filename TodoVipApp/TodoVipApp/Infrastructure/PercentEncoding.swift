//
//  PercentEncoding.swift
//  TodoVipApp
//
//  Created by song on 2023/04/03.
//

import Foundation

extension TodoRequestManager {
  func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")
    
    return string
      .addingPercentEncoding(withAllowedCharacters: characterSet)!
      .replacingOccurrences(of: " ", with: "+")
      .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
  }
  
  func encodeParameters(parameters: [String: String]) -> Data? {
    let parameterArray: [String] = parameters.map { (key, value) -> String in
      return "\(key)=\(self.percentEscapeString(value))"
    }
    return parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
  }
}

