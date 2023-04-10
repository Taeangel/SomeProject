//
//  WorkerAPI.swift
//  TodoVipApp
//
//  Created by song on 2023/04/10.
//

import Foundation

protocol ApiManagerProtocol {}

protocol TodoWorkerUsecase: ApiManagerProtocol {}

extension TodoWorkerUsecase {
  var todoStorage: TodoStorage {
    return TodoStorage(todoApiManager: apiManager)
  }
  
  var todoRepository: TodoRepository {
    return TodoRepository(todoStorageable: todoStorage)
  }
  
  var todoUsecase: TodoUsecase {
    return TodoUsecase(todoRepository: todoRepository)
  }
}

extension ApiManagerProtocol {
  var apiManager: TodoApiManager {
    return TodoApiManager(session: URLSession.shared)
  }
}
