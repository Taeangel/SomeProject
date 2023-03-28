//
//  FetchUseCase.swift
//  TodoVipApp
//
//  Created by song on 2023/03/28.
//

import Foundation

protocol FetchUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO
}

final class FetchUsecase {
  private let fetchRepository: FetchRepositoriable
  
  init(fetchRepository: FetchRepositoriable) {
    self.fetchRepository = fetchRepository
  }
}

extension FetchUsecase: FetchUsecasealbe {
  func fetchTodoList(page: Int, perPage: Int) async throws -> TodoListDTO {
    try await fetchRepository.fetchtodoList(page: page, perPage: perPage)
  }
}
