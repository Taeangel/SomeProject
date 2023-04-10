//
//  TodoEntity.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

struct TodoEntity {
  let id: Int?
  let title: String?
  let isDone: Bool?
  let updatedAt: String?
  
  init(datunm: Datum) {
    self.id = datunm.id
    self.title = datunm.title
    self.isDone = datunm.isDone
    
    
    self.updatedAt = datunm.updatedAt
  }
  
  
  var updatedTime: String {
    guard let findDateT = updatedAt?.firstIndex(of: "T"),
          let findDateDot = updatedAt?.firstIndex(of: ".") else {
      return ""
    }
    
    guard var updatedTime = updatedAt?[findDateT...findDateDot] else {
      return ""
    }
    
    updatedTime.removeFirst()
    
    return "\(updatedTime.prefix(5))"
  }
  
  
  var updatedDate: String {
    guard let findDateT = updatedAt?.firstIndex(of: "T") else {
      return ""
    }
    
    guard var updatedDate = updatedAt?[...findDateT] else {
      return ""
    }
    
    updatedDate.removeLast()
    
    return "\(updatedDate)"
  }
  
}
