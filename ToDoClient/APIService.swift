//
//  APIService.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}

enum JSONError:Error {
    case deserializationError
}

struct EndPoint {
    static var baseEndPoint:String {
        
        return "http://localhost:8080"
//        return UserDefaults.standard.string(forKey: "baseURL") ?? ""
    }
    static let addTask = "/addTask/"
    static let completed = "/completed/all"
    static let incomplete = "incomplete/all/"
    static let all = "/all/"
    
    static func getTask(taskID:String) -> String {
        return "/task/\(taskID)"
    }
    
    static func completeTask(taskID:String) -> String {
        return "/completeTask/\(taskID)/"
    }
    
    static func removeTask(taskID:String) -> String {
        return "/removeTask/\(taskID)/"

    }

}

class APIService {
    

    static let session = URLSession.shared
    
    
    static func addTask(task:Task, completion: @escaping (Result<Task>) -> Void ) {
        
        let urlString = EndPoint.baseEndPoint + EndPoint.addTask
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = task.toJSON()
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                completion(.error(err))
                return
            }
            
            if let data = data, let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String], let taskID = dict?["taskID"] {
                
                var updatedTask = task
                updatedTask.uid = taskID
                completion(.success(updatedTask))
            
            } else {
                completion(.error(JSONError.deserializationError))

            }
        
        }
        
        task.resume()
        
        
    }
    
    static func fetchAllTasks(completion: @escaping (Result<[Task]>) -> Void ) {
        
        let urlString = EndPoint.baseEndPoint + EndPoint.all
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            
            if let err = error {
                completion(.error(err))
                return
            }
            
            if let data = data, let arr = try? JSONSerialization.jsonObject(with: data, options: []), let typedArr = arr as? [[String: AnyObject]] {
                
                let mapped = typedArr.flatMap(Task.init)
                completion(.success(mapped))
                
            } else {
                completion(.error(JSONError.deserializationError))
                
            }
            
        }
        
        task.resume()
        
        
    }
    
    static func completeTask(task:Task,completion: @escaping () -> Void ) {
        let urlString = EndPoint.baseEndPoint + EndPoint.completeTask(taskID: task.uid)
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                completion()
            }
        }
        
        task.resume()

    }
    
    static func deleteTask(task:Task,completion: @escaping () -> Void ) {
        let urlString = EndPoint.baseEndPoint + EndPoint.removeTask(taskID: task.uid)
        guard let url = URL(string: urlString) else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error == nil {
                completion()
            }
        }
        
        task.resume()
        
    }

    
    
    
    
    

}
