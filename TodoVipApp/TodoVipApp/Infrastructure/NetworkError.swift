//
//  NetworkError.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

enum NetworkError: Error {
  case network(error: Error)
  case decoding
  case unknown
  case unauthorized
  case noContent
  case badStatus(code: Int)
}
