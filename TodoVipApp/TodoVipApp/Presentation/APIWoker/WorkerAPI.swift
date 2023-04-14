//
//  WorkerAPI.swift
//  TodoVipApp
//
//  Created by song on 2023/04/10.
//

import Foundation

protocol ApiManagerProtocol {
  var apiManager: TodoApiManager { get set }
}

protocol TodoWorkerUsecase: ApiManagerProtocol {}

extension TodoWorkerUsecase {
  var todoStorage: TodoAPIStorage {
    return TodoAPIStorage(todoApiManager: apiManager)
  }
  
  var todoRepository: TodoRepository {
    return TodoRepository(todoStorageable: todoStorage)
  }
  
  var todoUsecase: TodoUsecase {
    return TodoUsecase(todoRepository: todoRepository)
  }
}

struct MockURLSession: Requestable  {
  func request(_ request: TodoRequestManager) async throws -> Data {
    return Data()
  }
}
