//
//  TodoPersistent.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 22.11.2024.
//

import CoreData
import Foundation

final class TodoPersistent {
    private static let context = AppDelegate.persistentContainer.viewContext
    
    static func save(_ todo: Todo) {
        let entity = getEntity(for: todo) ?? TodosEntity(context: context)
        
        entity.id = Int64(todo.id)
        entity.todo = todo.todo
        entity.completed = todo.completed
        entity.userId = Int64(todo.userId ?? 0)
        entity.date = todo.date ?? Date()
        print("создвл \(entity)")
        saveContext()
    }
    
    static func update(_ todo: Todo) {
        
        let fetchRequest: NSFetchRequest<TodosEntity> = TodosEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", todo.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            
            if let existingTodo = result.first {
                existingTodo.completed = todo.completed
                existingTodo.todo = todo.todo
                saveContext()
                print("обновил")
                
            }
        } catch {
            print("Ошибка в обновлении: \(error)")
        }
    }
    
    static func delete(_ todo: Todo) {
        guard let entity = getEntity(for: todo) else { return }
        context.delete(entity)
        saveContext()
    }
    
    static func fetchAll() -> [Todo] {
        let request: NSFetchRequest<TodosEntity> = TodosEntity.fetchRequest()
        
        do {
            let objects = try context.fetch(request)
            return objects.map {
                Todo(id: Int($0.id),
                     todo: $0.todo ?? "",
                     completed: $0.completed,
                     userId: Int($0.userId),
                     date: $0.date ?? Date())
            }
        } catch {
            debugPrint("Fetch todos error: \(error)")
            return []
        }
    }
    
    static func getEntity(for todo: Todo) -> TodosEntity? {
        let request: NSFetchRequest<TodosEntity> = TodosEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %d", todo.id)
        
        do {
            return try context.fetch(request).first
        } catch {
            debugPrint("Fetch error: \(error)")
            return nil
        }
    }
    
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("я сюда зашел")
                NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
            } catch {
                debugPrint("Save context error: \(error)")
            }
        }
    }
    
}
