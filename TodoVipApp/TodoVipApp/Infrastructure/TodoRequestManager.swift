//
//  TodoRequestManager.swift
//  TodoVipApp
//
//  Created by song on 2023/03/27.
//

import Foundation

enum TodoRequestManager {
  case getTodos(page: Int, orderBy: String = "desc", perPage: Int)
  case modify(id: Int, title: String, isDone: Bool)
  case delete(id: Int)
  case postTodo(title: String, isDone: Bool)
  
  var todoBaseURL: String {
   return "https://phplaravel-574671-2962113.cloudwaysapps.com/api/v1/"
  }
  
  private var baseURL: String {
    switch self {
    case .getTodos:
      return todoBaseURL
    case .modify:
      return todoBaseURL
    case .delete:
      return todoBaseURL
    case .postTodo:
      return todoBaseURL
    }
  }
  
  private var endPoint: String {
    
    switch self {
    case .getTodos:
      return "todos?"
    case let .modify(id, _, _):
      return "todos/\(id)"
    case let .delete(id):
      return "todos/\(id)"
    case .postTodo:
      return "todos"
    }
  }
  
  private var method: HTTPMethod {
    switch self {
    case .getTodos:
      return .get
    case .modify:
      return .put
    case .delete:
      return .delete
    case .postTodo:
      return .post
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
    case .modify:
      return nil
    case .delete:
      return nil
    case .postTodo:
      return nil
    }
  }
  
  private var headerFields: [String: String]? {
    switch self {
    case .getTodos:
      return ["Content-Type": "application/json"]
    case .modify:
      return ["Content-Type": "application/x-www-form-urlencoded"]
    case .delete:
      return ["Accept": "application/json"]
    case .postTodo:
      return ["Accept": "application/json", "Content-Type": "multipart/form-data"]
    }
  }
  
  private var bodyData: Data? {
    switch self {
    case .getTodos:
      return nil
    case let .modify(_ , title, isDone):
      return encodeParameters(parameters: ["title": title, "is_done": "\(isDone)"])
    case .delete:
      return nil
    case .postTodo:
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
  
  func percentEscapeString(_ string: String) -> String {
    var characterSet = CharacterSet.alphanumerics
    characterSet.insert(charactersIn: "-._* ")
    
    return string
      .addingPercentEncoding(withAllowedCharacters: characterSet)!
      .replacingOccurrences(of: " ", with: "+")
      .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
  }
  
  func encodeParameters(parameters: [String: String]) -> Data? {
    let parameterArray: [String] = parameters.map { (key, value) -> String in
      return "\(key)=\(self.percentEscapeString(value))"
    }
     return parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
  }
}
