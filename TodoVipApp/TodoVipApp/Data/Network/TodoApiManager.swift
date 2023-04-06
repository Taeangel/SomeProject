//
//  ApiManager.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

protocol TodoAPIProtocol {
  func requestData(_ request: TodoRequestManager) async throws -> Data
}

protocol Requestable {
  func request(_ request: TodoRequestManager) async throws -> Data
}

struct TodoApiManager: TodoAPIProtocol {
  
  let session: Requestable
  
  init(session: Requestable) {
    self.session = session
  }
  
  func requestData(_ request: TodoRequestManager) async throws -> Data {
    return try await session.request(request)
  }
}

extension URLSession: Requestable {
  func request(_ request: TodoRequestManager) async throws -> Data {
    
    let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
    
    guard let response = response as? HTTPURLResponse else {
      throw NetworkError.developerProblem
    }
    
    if response.statusCode == 422 {
      throw NetworkError.badRequest
    }
    
    if response.statusCode == 429 {
      throw NetworkError.fastRequest
    }
    
    guard (200..<300).contains(response.statusCode) else {
      throw NetworkError.badStatus(code: response.statusCode)
    }
    
    return data
  }
}

