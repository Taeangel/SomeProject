//
//  TodoDTO.swift
//  TodoVipApp
//
//  Created by song on 2023/04/05.
//

import Foundation

// MARK: - Todo
struct TodoDataDTO: Codable {
    let data: TodoDTO
    let message: String?
}

// MARK: - DataClass
struct TodoDTO: Codable {
    let id: Int
    let title: String
    let isDone: Bool

    enum CodingKeys: String, CodingKey {
        case id, title
        case isDone = "is_done"
    }
}
