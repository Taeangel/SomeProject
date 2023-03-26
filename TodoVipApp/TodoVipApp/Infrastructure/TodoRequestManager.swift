//
//  TodoRequestManager.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

enum TodoRequestManager {
  case getAllTodo
  
  private var baseURL: String {
    return "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v1/"
  }
  
  
}
