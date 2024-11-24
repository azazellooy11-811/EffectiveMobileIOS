//
//  ToDoResponse.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 22.11.2024.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [Todo]
    let total: Int
    let skip: Int
    let limit: Int
}
