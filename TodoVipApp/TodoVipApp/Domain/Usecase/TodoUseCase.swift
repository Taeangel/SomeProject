//
//  TodoUseCase.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListEntity?
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoEntity
  func deleteTodo(id: Int) async throws -> TodoEntity
  func postTodo(todo: TodoPostDTO) async throws -> TodoEntity
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListEntity?
}

final class TodoUsecase {
  private let todoRepository: TodoRepositoriable
  
  init(todoRepository: TodoRepositoriable) {
    self.todoRepository = todoRepository
  }
}

extension TodoUsecase: TodoUsecasealbe {

  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoEntity {
    let todoDataDTO = try await todoRepository.modifyTodo(id: id, title: title, isDone: isDone)
    return TodoEntity(datunm: todoDataDTO)
  }
  
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListEntity? {
    let todoListDTO = try await todoRepository.fetchtodoList(page: page, perPage: perPage)
    return TodoListEntity(
      todoEntity: todoListDTO.data.map { $0.map { TodoEntity(datunm: $0) } },
      meta: todoListDTO.meta)
  }
  
  func deleteTodo(id: Int) async throws -> TodoEntity {
    let todoDataDTO = try await todoRepository.deleteTodo(id: id)
    return TodoEntity(datunm: todoDataDTO)
  }
  
  func postTodo(todo: TodoPostDTO) async throws -> TodoEntity {
    let todoDataDTO = try await todoRepository.postTodo(todo: todo)
    return TodoEntity(datunm: todoDataDTO)
  }
  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListEntity? {
    let todoListDTO = try await todoRepository.fetchSearchTodoList(page: page, perPage: perPage, query: query)
    return TodoListEntity(
      todoEntity: todoListDTO.data.map { $0.map { TodoEntity(datunm: $0) } },
      meta: todoListDTO.meta)
  }
  
  func fetchTodo(id: Int) async throws -> TodoEntity {
    let todoDataDTO = try await todoRepository.fetchTodo(id: id)
    return TodoEntity(datunm: todoDataDTO)
  }
}
