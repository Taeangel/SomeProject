//
//  FetchRepositorty.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

final class TodoRepository {
  private let todoStorageable: TodoStorageable
  
  init(todoStorageable: TodoStorageable) {
    self.todoStorageable = todoStorageable
  }
}

extension TodoRepository: TodoRepositoriable {

  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListDTO {
    try await todoStorageable.fetchSearchTodoList(page: page, perPage: perPage, query: query)
  }
  
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await todoStorageable.fetchTodoList(page: page, perPage: perPage)
  }
  
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO {
    try await todoStorageable.modifyTodo(id: id, title: title, isDone: isDone)
  }
  
  func deleteTodo(id: Int) async throws -> TodoDataDTO {
    try await todoStorageable.deleteTodo(id: id)
  }
  
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO {
    try await todoStorageable.postTodo(todo: todo)
  }
  
  func fetchTodo(id: Int) async throws -> TodoDataDTO {
    try await todoStorageable.fetchTodo(id: id)
  }
}
