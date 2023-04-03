//
//  FetchRepositorable.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol TodoRepositoriable {
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO
  func modifyTodo(id: Int, title: String, isDone: Bool) async throws
  func deleteTodo(id: Int) async throws
  func postTodo(todo: TodoDTO) async throws
}
