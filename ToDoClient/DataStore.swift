//
//  DataStore.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation

class DataStore {
    
    static var tasks: [Task] = [] {
        didSet{
            if shouldNotify {
                handler?()
            }
        }
    }
    
    static var shouldNotify = true
    static var handler: (() -> Void)?
    
    static var completedTasks: [Task] {
        return tasks.filter({$0.completed})
    }
    
    static var incompleteTasks: [Task] {
        return tasks.filter({!$0.completed})
    }
    
    static func addTask(task:Task) {
        tasks.append(task)
    }
    
    static func fetchAll(completion: @escaping () -> ()) {
        APIService.fetchAllTasks {result in
            
            switch result {
            case .success(let tasks):
                DispatchQueue.main.async {
                    DataStore.tasks = tasks
                    completion()
                }
            case .error:
                break
            }
        }
    }
    
    static func completeTask(at indexPath:IndexPath, completion: @escaping () -> Void) {
        
        let task:Task
        switch indexPath.section {
        case 0:
            task = incompleteTasks[indexPath.row]
        case 1:
            task = completedTasks[indexPath.row]
        default:
            task = .empty
        }
        
        APIService.completeTask(task: task, completion: completion)
    }
    
    static func deleteTask(at indexPath:IndexPath, completion: @escaping () -> Void) {
        shouldNotify = false
        let task:Task
        var index:Int = indexPath.row
        switch indexPath.section {
        case 0:
            task = incompleteTasks[indexPath.row]
        case 1:
            task = completedTasks[indexPath.row]
            index += incompleteTasks.count
        default:
            task = .empty
        }
        
        tasks.remove(at: index)
        
        APIService.deleteTask(task: task, completion: completion)
    }
}
