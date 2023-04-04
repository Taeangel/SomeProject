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
}
