//
//  AddModels.swift
//  TodoVipApp
//
//  Created by song on 2023/04/03.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Add
{
  // MARK: Use cases
  
  enum PostTodo
  {
    struct Request
    {
      var todo: TodoDTO
    }
    struct Response
    {
      let title = ""
      let isDone = false
    }
    struct ViewModel
    {
      let title = ""
      let isDone = false
    }
  }
}
