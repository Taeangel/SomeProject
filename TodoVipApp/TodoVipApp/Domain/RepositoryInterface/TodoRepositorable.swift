//
//  FetchRepositorable.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoRepositoriable {
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws -> TodoDataDTO
  func deleteTodo(id: Int) async throws -> TodoDataDTO
  func postTodo(todo: TodoPostDTO) async throws -> TodoDataDTO
  func fetchSearchTodoList(page: Int, perPage: Int ,query: String) async throws -> TodoListDTO
  func fetchTodo(id: Int) async throws -> TodoDataDTO
}
