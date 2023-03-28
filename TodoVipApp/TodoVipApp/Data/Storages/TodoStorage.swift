//
//  TodoStorage.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol FetchStorageable: AnyObject {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
}

final class FetchStorage {
  private let todoApiManager: TodoApiManager
  
  init(todoApiManager: TodoApiManager) {
    self.todoApiManager = todoApiManager
  }
}

extension FetchStorage: FetchStorageable {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    let data = try await todoApiManager.requestData(.getTodos(page: page, perPage: perPage))
    
    do {
      return try JSONDecoder().decode(TodoListDTO.self, from: data)
    } catch {
      throw  NetworkError.decoding
    }
  }
}
