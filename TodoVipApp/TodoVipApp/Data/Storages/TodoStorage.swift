//
//  TodoStorage.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoStorageable: AnyObject {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws
  func deleteTodo(id: Int) async throws
  func postTodo(todo: TodoDTO) async throws
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListDTO
}

final class TodoStorage {
  private let todoApiManager: TodoApiManager
  
  init(todoApiManager: TodoApiManager) {
    self.todoApiManager = todoApiManager
  }
}

extension TodoStorage: TodoStorageable {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    let data = try await todoApiManager.requestData(.getTodos(page: page, perPage: perPage))
    
    do {
      return try JSONDecoder().decode(TodoListDTO.self, from: data)
    } catch {
      throw  NetworkError.decoding
    }
  }
  
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws {
    do {
      let _ = try await todoApiManager.requestData(.modify(id: id, title: title, isDone: isDone))
    } catch {
      throw NetworkError.unknown
    }
  }
  
  func deleteTodo(id: Int) async throws {
    do {
      let _ = try await todoApiManager.requestData(.delete(id: id))
    } catch {
      throw NetworkError.unknown
    }
  }
  
  func postTodo(todo: TodoDTO) async throws {
    do {
      let _ = try await todoApiManager.requestData(.postTodo(todo: todo))
    } catch {
      throw NetworkError.unknown
    }
  }
  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListDTO {
    let data = try await todoApiManager.requestData(.getSearchTodos(page: page, query: query, perPage: perPage))
    
    do {
      return try JSONDecoder().decode(TodoListDTO.self, from: data)
    } catch {
      throw  NetworkError.decoding
    }
  }
}
