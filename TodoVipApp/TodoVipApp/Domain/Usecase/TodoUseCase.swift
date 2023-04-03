//
//  TodoUseCase.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws
  func deleteTodo(id: Int) async throws
  func postTodo(todo: TodoDTO) async throws
}

final class TodoUsecase {
  private let todoRepository: TodoRepositoriable
  
  init(todoRepository: TodoRepositoriable) {
    self.todoRepository = todoRepository
  }
}

extension TodoUsecase: TodoUsecasealbe {
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws {
    try await todoRepository.modifyTodo(id: id, title: title, isDone: isDone)
  }
  
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await todoRepository.fetchtodoList(page: page, perPage: perPage)
  }
  
  func deleteTodo(id: Int) async throws {
    try await todoRepository.deleteTodo(id: id)
  }
  
  func postTodo(todo: TodoDTO) async throws {
    try await todoRepository.postTodo(todo: todo)
  }
}
