//
//  NetworkError.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

enum NetworkError: Error {
  case decoding
  case noContent
  case badRequest
  case developerProblem
  case badStatus(code: Int)
  case fastRequest
}

extension NetworkError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case let .badStatus(error):
      return "상태코드에러입니다.\(error)"
    case .badRequest:
      return "잘못된 정보를 입력하셨습니다. 할일은 6글자 이상 입력해 주세요"
    case .developerProblem:
      return "개발자에게 문의해 주십시오"
    case .fastRequest:
      return "지금 서버에 문제가 있습니다 죄송합니다!"
    case .decoding:
      return "디코딩에러입니다!!"
    default:
      return ":"
    }
  }
}
