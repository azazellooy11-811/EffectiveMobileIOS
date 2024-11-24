//
//  ToDoListViewModelTests.swift
//  ToDoListViewModelTests
//
//  Created by Азалия Халилова on 24.11.2024.
//

import XCTest
@testable import EffectiveMobile

final class ToDoListViewModelTests: XCTestCase {
    
    var viewModel: TodoListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TodoListViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    func testFetchTodos() {
        let expectation = self.expectation(description: "Fetch todos from Core Data")
        
        var isFulfilled = false
        viewModel.reloadTable = {
            if !isFulfilled {
                XCTAssertFalse(self.viewModel.todos.isEmpty, "Todos should not be empty")
                isFulfilled = true
                expectation.fulfill()
            }
        }
        
        viewModel.fetchTodos()
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testAddTodo() {
        let newTodo = Todo(id: 1, todo: "Test Todo", completed: false, userId: 1, date: Date())
        viewModel.add(todo: newTodo)
        
        XCTAssertEqual(viewModel.todos.count, 1, "Todo count should be 1 after adding a new todo")
        XCTAssertEqual(viewModel.todos.first?.todo, "Test Todo", "First todo should be 'Test Todo'")
    }
    
    func testUpdateTodoCompletionStatus() {
        let newTodo = Todo(id: 1, todo: "Test Todo", completed: false, userId: 1, date: Date())
        viewModel.add(todo: newTodo)
        
        let indexPath = IndexPath(row: 0, section: 0)
        viewModel.updateTodoCompletionStatus(at: indexPath, isSelected: true)
        
        XCTAssertTrue(viewModel.todos[0].completed, "The todo's completion status should be true")
    }
    
    func testFilterTodos() {
        let todo1 = Todo(id: 1, todo: "Buy milk", completed: false, userId: 1, date: Date())
        let todo2 = Todo(id: 2, todo: "Walk the dog", completed: false, userId: 1, date: Date())
        
        viewModel.add(todo: todo1)
        viewModel.add(todo: todo2)
        
        viewModel.filterTodos(by: "milk")
        
        XCTAssertEqual(viewModel.filteredTodos.count, 1, "Filtered todos count should be 1")
        XCTAssertEqual(viewModel.filteredTodos.first?.todo, "Buy milk", "The filtered todo should be 'Buy milk'")
    }
}
