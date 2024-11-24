//
//  Todo.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 22.11.2024.
//

import Foundation

struct Todo: Codable, Identifiable {
    let id: Int
    var todo: String
    var completed: Bool
    let userId: Int?
    let date: Date?
}
