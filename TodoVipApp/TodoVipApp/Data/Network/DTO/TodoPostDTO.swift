//
//  TodoDTO.swift
//  TodoVipApp
//
//  Created by song on 2023/04/03.
//

import Foundation

struct TodoPostDTO {
  let title: String
  let isDone: Bool
  let boundary: String = UUID().uuidString
}
