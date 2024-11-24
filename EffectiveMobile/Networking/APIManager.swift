//
//  APIManager.swift
//  EffectiveMobile
//
//  Created by Азалия Халилова on 22.11.2024.
//

import UIKit

class APIManager {
    
    private let url = "https://dummyjson.com/todos"
    
    func fetchTodos(completion: @escaping (Result<TodoResponse, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            do {
                let todoResponse = try JSONDecoder().decode(TodoResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todoResponse))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        } .resume()
    }
}
