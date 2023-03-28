//
//  FetchRepositorty.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

final class FetchRepository {
  private let fetchStorageable: FetchStorageable
  
  init(fetchStorageable: FetchStorageable) {
    self.fetchStorageable = fetchStorageable
  }
}

extension FetchRepository: FetchRepositoriable {
  func fetchtodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await fetchStorageable.fetchTodoList(page: page, perPage: perPage)
  }
}
