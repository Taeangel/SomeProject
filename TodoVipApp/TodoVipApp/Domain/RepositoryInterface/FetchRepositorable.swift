//
//  FetchRepositorable.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol FetchRepositoriable {
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO
}
