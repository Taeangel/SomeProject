//
//  TodoEntity.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

struct TodoEntity {
  var id: Int?
  var title: String?
  var isDone: Bool?
  var updatedAt: String?
  
  init(datunm: TodoData) {
    self.id = datunm.id
    self.title = datunm.title
    self.isDone = datunm.isDone
    self.updatedAt = datunm.updatedAt
  }
  
  init(datunm: TodoDataDTO) {
    self.id = datunm.data.id
    self.title = datunm.data.title
    self.isDone = datunm.data.isDone
    self.updatedAt = datunm.data.updatedAt
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
