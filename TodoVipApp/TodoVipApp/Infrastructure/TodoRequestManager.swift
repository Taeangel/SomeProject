//
//  TodoRequestManager.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

enum TodoRequestManager {
  case getTodos(page: Int, orderBy: String = "desc", perPage: Int)
  
  private var baseURL: String {
    return "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v1/"
  }
  
  private var endPoint: String {
    
    switch self {
    case .getTodos:
      return "todos?"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getTodos:
      return .get
    }
  }
  
  private var parameters: [String: Any]? {
    switch self {
    case let .getTodos(page, orderBy, perPage):
      var params: [String: Any] = [:]
      params["page"] = page
      params["order_by"] = orderBy
      params["per_page"] = perPage
      return params
    }
  }
  
  private var headerFields: [String: String]? {
    switch self {
    case .getTodos:
      return ["Content-Type": "application/json"]
    }
  }
  
  private var bodyData: Data? {
    switch self {
    case .getTodos:
      return nil
    }
  }
  
  var urlRequest: URLRequest {
    var components = URLComponents(string: baseURL + endPoint)
    
    if let parameters {
      components?.queryItems = parameters.map { key, value in
        URLQueryItem(name: key, value: "\(value)")
      }
    }
    
    var request = URLRequest(url: (components?.url) ?? URL(fileURLWithPath: ""))
    request.httpMethod = method.rawValue
    
    if let headerFields {
      headerFields.forEach {
        request.addValue($0.value, forHTTPHeaderField: $0.key)
      }
    }
    
    if let bodyData {
      request.httpBody = bodyData
    }
    
    return request
  }
}

