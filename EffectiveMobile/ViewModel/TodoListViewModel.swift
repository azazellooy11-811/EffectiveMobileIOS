//
//  TodoListViewModel.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 21.11.2024.
//

import UIKit
import CoreData

protocol TodoListViewModelProtocol {
    var todos: [Todo] { get }
    var reloadTable: (() -> Void)? { get set }
    
    func fetchTodos()
    func refreshTodosFromAPI()
    func delete(todo: Todo)
}

class TodoListViewModel: TodoListViewModelProtocol {
    private(set) var todos: [Todo] = []
    private(set) var filteredTodos: [Todo] = []
    private let persistent = TodoPersistent()
    private let apiService = APIManager()
    
    var reloadTable: (() -> Void)?
    
    init() {
        if TodoPersistent.fetchAll().isEmpty {
            refreshTodosFromAPI()
        } else {
            fetchTodos()
        }
    }
    
    func getNextId() -> Int {
        return (todos.map { $0.id }.max() ?? 0) + 1
    }
    
    func add(todo: Todo) {
        todos.append(todo)
        reloadTable?()
    }
    
    func fetchTodos() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let allTodos = TodoPersistent.fetchAll()
            
            DispatchQueue.main.async {
                self?.todos = allTodos
                self?.filterTodos(by: "")
                self?.reloadTable?()
            }
        }
    }
    
    func refreshTodosFromAPI() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.apiService.fetchTodos { result in
                switch result {
                case .success(let apiTodos):
                    apiTodos.todos.forEach { todo in
                        TodoPersistent.save(todo)
                    }
                    self?.fetchTodos()
                case .failure(let error):
                    print("Failed to fetch todos from API: \(error)")
                }
            }
        }
    }
    
    func updateTodoCompletionStatus(at indexPath: IndexPath, isSelected: Bool) {
        var todo = todos[indexPath.row]
        todo.completed = isSelected
        
        TodoPersistent.update(todo)
        
        todos[indexPath.row] = todo
    }
    
    func delete(todo: Todo) {
        TodoPersistent.delete(todo)
    }
    
    func filterTodos(by searchText: String) {
           if searchText.isEmpty {
               filteredTodos = todos
           } else {
               filteredTodos = todos.filter { $0.todo.lowercased().contains(searchText.lowercased()) }
           }
           reloadTable?()
       }
}
