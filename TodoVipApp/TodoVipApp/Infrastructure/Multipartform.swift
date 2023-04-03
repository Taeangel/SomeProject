//
//  Multipartform.swift
//  TodoVipApp
//
//  Created by song on 2023/04/03.
//

import Foundation

struct MultipartForm: Hashable, Equatable {
  init(parts: [Datapart] = [], boundary: String = UUID().uuidString) {
    self.parts = parts
    self.boundary = boundary
  }
  
  var boundary: String
  var parts: [Datapart]
  
  var bodyData: Data {
    var body = Data()
    for part in self.parts {
      body.append("--\(self.boundary)\r\n")
      body.append("Content-Disposition: form-data; name=\"\(part.name)\"")
      if let filename = part.filename?.replacingOccurrences(of: "\"", with: "_") {
        body.append("; filename=\"\(filename)\"")
      }
      body.append("\r\n")
      if let contentType = part.contentType {
        body.append("Content-Type: \(contentType)\r\n")
      }
      body.append("\r\n")
      body.append(part.data)
      body.append("\r\n")
    }
    body.append("--\(self.boundary)--\r\n")
    
    return body
  }
}

struct Datapart: Hashable, Equatable {
  var name: String
  var data: Data
  var filename: String?
  var contentType: String?
  
  var value: String? {
    get {
      return String(bytes: self.data, encoding: .utf8)
    }
    set {
      guard let value = newValue else {
        self.data = Data()
        return
      }
      self.data = value.data(using: .utf8, allowLossyConversion: true)!
    }
  }
  
  init(name: String, data: Data, filename: String? = nil, contentType: String? = nil) {
    self.name = name
    self.data = data
    self.filename = filename
    self.contentType = contentType
  }
  
  init(name: String, value: String) {
    let data = value.data(using: .utf8, allowLossyConversion: true)!
    self.init(name: name, data: data, filename: nil, contentType: nil)
  }
}

fileprivate extension Data {
  mutating func append(_ string: String) {
    self.append(string.data(using: .utf8, allowLossyConversion: true)!)
  }
}
