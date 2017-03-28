//
//  AddTaskViewController.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import Foundation
import UIKit

class AddTaskViewController: UIViewController {
    
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descriptionField: UITextView!
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let title = titleField.text, title.characters.count > 0 else {
            return
        }
        
        let description = descriptionField.text ?? ""
        
        let task = Task(uid: "", description: description, title: title)
        
        APIService.addTask(task: task) { result in
            
            switch result {
            case .success(let task):
                DataStore.addTask(task: task)
            case .error(let error):
                print(error.localizedDescription)
            }
            
        }

    }
    
}
