//
//  AppDelegate.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 21.11.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if let window {
            let navigationController = UINavigationController()
            let toDoListViewController = ToDoListViewController()
            
            navigationController.viewControllers = [toDoListViewController]
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
        
        return true
    }
}

