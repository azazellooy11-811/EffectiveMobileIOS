//
//  TaskViewModel.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 21.11.2024.
//

import UIKit

protocol TaskViewModelProtocol {
    var todo: Todo { get set }
    func saveChanges(todo: Todo)
    func createToDo(todo: Todo)
}

class TaskViewModel: TaskViewModelProtocol {
    var todo: Todo
    
    init(todo: Todo) {
        self.todo = todo
    }
    
    func saveChanges(todo: Todo) {
        TodoPersistent.update(todo)
    }
    
    func createToDo(todo: Todo) {
        TodoPersistent.save(todo)
    }
}
