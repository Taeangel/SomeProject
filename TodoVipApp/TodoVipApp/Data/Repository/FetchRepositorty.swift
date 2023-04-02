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
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await todoStorageable.fetchTodoList(page: page, perPage: perPage)
  }
  
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws {
    try await todoStorageable.modifyTodo(id: id, title: title, isDone: isDone)
  }
  
}
