//
//  TodoUseCase.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO
  func deleteTodo(id: Int) async throws -> TodoDataDTO
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListDTO
}

final class TodoUsecase {
  private let todoRepository: TodoRepositoriable
  
  init(todoRepository: TodoRepositoriable) {
    self.todoRepository = todoRepository
  }
}

extension TodoUsecase: TodoUsecasealbe {

  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO {
    try await todoRepository.modifyTodo(id: id, title: title, isDone: isDone)
  }
  
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await todoRepository.fetchtodoList(page: page, perPage: perPage)
  }
  
  func deleteTodo(id: Int) async throws -> TodoDataDTO {
    try await todoRepository.deleteTodo(id: id)
  }
  
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO {
    try await todoRepository.postTodo(todo: todo)
  }
  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListDTO {
    try await todoRepository.fetchSearchTodoList(page: page, perPage: perPage, query: query)
  }
  
  func fetchTodo(id: Int) async throws -> TodoDataDTO {
    try await todoRepository.fetchTodo(id: id)
  }
  
}
