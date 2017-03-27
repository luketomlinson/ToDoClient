//
//  DataStore.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation

class DataStore {
    
    static var tasks: [Task] = []
    
    static func addTask(task:Task) {
        tasks.append(task)
    }
    
    static func fetchAll(completion: @escaping () -> ()) {
        APIService.fetchAllTasks {result in
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                completion()
            case .error(let err):
                break
            }
        }
    }
}
