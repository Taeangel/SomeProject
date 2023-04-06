//
//  TodoStorage.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoStorageable: AnyObject {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO
  func deleteTodo(id: Int) async throws -> TodoDataDTO
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListDTO
  func fetchTodo(id: Int) async throws -> TodoDataDTO
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
      
      throw NetworkError.decoding
    }
  }
  
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO {
    let data = try await todoApiManager.requestData(.modify(id: id, title: title, isDone: isDone))
    
    do {
      return try JSONDecoder().decode(TodoDataDTO.self, from: data)
    } catch {
      
      throw NetworkError.decoding
    }
    
  }
  
  func deleteTodo(id: Int) async throws -> TodoDataDTO {
    let data = try await todoApiManager.requestData(.delete(id: id))
    
    do {
      return try JSONDecoder().decode(TodoDataDTO.self, from: data)
    } catch {
      
      throw NetworkError.decoding
    }
  }
  
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO {
    let data = try await todoApiManager.requestData(.postTodo(todo: todo))
    
    do {
      return try JSONDecoder().decode(TodoDataDTO.self, from: data)
    } catch {
      
      throw NetworkError.decoding
    }
  }
  
  func fetchSearchTodoList(page: Int, perPage: Int, query: String) async throws -> TodoListDTO {
    let data = try await todoApiManager.requestData(.getSearchTodos(page: page, query: query, perPage: perPage))
    
    do {
      return try JSONDecoder().decode(TodoListDTO.self, from: data)
    } catch {
      throw NetworkError.decoding
    }
  }
  
  func fetchTodo(id: Int) async throws -> TodoDataDTO {
    let data = try await todoApiManager.requestData(.fetchTodo(id: id))
    
    do {
      return try JSONDecoder().decode(TodoDataDTO.self, from: data)
    } catch {
      
      throw NetworkError.decoding
    }
  }
}
