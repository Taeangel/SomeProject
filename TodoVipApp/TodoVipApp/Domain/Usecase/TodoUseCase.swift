//
//  TodoUseCase.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListEntity?
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoEntityData
  func deleteTodo(id: Int) async throws -> TodoEntityData
  func postTodo(todo: TodoPostDTO) async throws -> TodoEntityData
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListEntity?
  func fetchTodo(id: Int) async throws -> TodoEntityData
}

final class TodoUsecase {
  private let todoRepository: TodoRepositoriable
  
  init(todoRepository: TodoRepositoriable) {
    self.todoRepository = todoRepository
  }
}

extension TodoUsecase: TodoUsecasealbe {

  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoEntityData {
    let todoDataDTO = try await todoRepository.modifyTodo(id: id, title: title, isDone: isDone)
    return TodoEntityData(todoEntity: TodoEntity(datunm: todoDataDTO), message: todoDataDTO.message)
  }
  
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListEntity? {
    let todoListDTO = try await todoRepository.fetchtodoList(page: page, perPage: perPage)
    return TodoListEntity(
      todoEntity: todoListDTO.data.map { $0.map { TodoEntity(datunm: $0) } },
      meta: todoListDTO.meta, message: todoListDTO.message)
  }
  
  func deleteTodo(id: Int) async throws -> TodoEntityData {
    let todoDataDTO = try await todoRepository.deleteTodo(id: id)
    return TodoEntityData(todoEntity: TodoEntity(datunm: todoDataDTO), message: todoDataDTO.message)
  }
  
  func postTodo(todo: TodoPostDTO) async throws -> TodoEntityData {
    let todoDataDTO = try await todoRepository.postTodo(todo: todo)
    return TodoEntityData(todoEntity: TodoEntity(datunm: todoDataDTO), message: todoDataDTO.message)
  }
  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListEntity? {
    let todoListDTO = try await todoRepository.fetchSearchTodoList(page: page, perPage: perPage, query: query)
    return TodoListEntity(
      todoEntity: todoListDTO.data.map { $0.map { TodoEntity(datunm: $0) } },
      meta: todoListDTO.meta, message: todoListDTO.message)
  }
  
  func fetchTodo(id: Int) async throws -> TodoEntityData {
    let todoDataDTO = try await todoRepository.fetchTodo(id: id)
    return TodoEntityData(todoEntity: TodoEntity(datunm: todoDataDTO), message: todoDataDTO.message)
  }
}
