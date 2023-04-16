//
//  MainModels.swift
//  TodoVipApp
//
//  Created by song on 2023/03/24.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum MainScene
{
  enum AddTodo {
    struct Request {
    }
    
    struct Response {
      var todoList: [String : [TodoEntity]]?
    }
    
    struct ViewModel {
      
      struct DisplayedTodo: Hashable {
        let id: Int
        var title: String
        var isDone: Bool
        var updatedTime: String
        var updatedDate: String
      }
      
      var displayedTodoList: [String: [DisplayedTodo]]
      var sections: [String]
    }
  }
  
  // MARK: - CheckBoxModify
  enum ModifyTodo
  {
    struct Request  // 뷰가 인터렉터한테 요청하는 데이터
    {
      var id: Int
      var title: String
      var isDone: Bool
    }
    struct Response //워커에서 들어온 데이터 - 날것의 데이터
    {
      var indexPath: IndexPath?
      var todoEntity: TodoEntity?
      var error: Error?
    }
    
    struct ViewModel // 프리젠터가 뷰에 전달하는 데이터
    {
      struct DisplayedTodo: Hashable {
        let id: Int
        let title: String
        let isDone: Bool
        let updatedTime: String
        let updatedDate: String
      }

      var indexPath: IndexPath?
      var disPlayTodo: DisplayedTodo?
      var error: NetworkError?
    }
  }
  
  // MARK: - FetchSearchTodoList

  enum FetchSearchTodoList
  {
    struct Request: FetchListRequestProtocol // 뷰가 인터렉터한테 요청하는 데이터
    {
      var quary: String?
      var page: Int = 1
      var perPage: Int = 10
    }
    struct Response: TodoListProtocol //워커에서 들어온 데이터 - 날것의 데이터
    {
      var isFetch: Bool?
      var error: Error?
      var todoList: [String: [TodoEntity]]?
      var page: Int
    }
  }
  
  // MARK: - DeleteTodo
  
  enum DeleteTodo
  {
    struct Request // 인터렉터로 보낼데이터
    {
      var id: Int
    }
    struct Response //프리젠터로 보낼 데이터
    {
      var indexPath: IndexPath?
      var error: Error?
    }
    struct ViewModel // 뷰로 보낼 데이터
    {
      var indexPath: IndexPath?
      var error: NetworkError?
    }
  }
  
  // MARK: - FetchTodoList
  
  enum FetchTodoList
  {
    struct Request: FetchListRequestProtocol // 뷰가 인터렉터한테 요청하는 데이터
    {
      var quary: String?
      var page: Int = 1
      var perPage: Int = 10
    }
    
    struct Response: TodoListProtocol //워커에서 들어온 데이터 - 날것의 데이터
    {
      var error: Error?
      var todoList: [String: [TodoEntity]]?
      var page: Int
      var isFetch: Bool?
    }
    
    struct ViewModel // 프리젠터가 뷰에 전달하는 데이터
    {
      struct DisplayedTodo: Hashable {
        let id: Int
        var title: String
        var isDone: Bool
        var updatedTime: String
        var updatedDate: String
      }
      
      var error: NetworkError?
      var isFetch: Bool?
      var page: Int?
      var displayedTodoList: [String: [DisplayedTodo]]
      var sections: [String]
    }
  }
}

protocol TodoListProtocol {
  var todoList: [String: [TodoEntity]]? { get set }
  var error: Error? { get set }
  var page: Int { get set }
  var isFetch: Bool? { get set }
}

protocol FetchListRequestProtocol {
  var quary: String? { get set }
  var page: Int { get set }
  var perPage: Int { get set }
}
