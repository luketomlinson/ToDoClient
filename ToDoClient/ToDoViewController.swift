//
//  ViewController.swift
//  ToDoClient
//
//  Created by Luke Tomlinson on 3/27/17.
//  Copyright © 2017 Luke Tomlinson. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    let apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: .main),forCellReuseIdentifier: "todoCell")
        
        DataStore.fetchAll() { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
}

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! ToDoTableViewCell
        let task = DataStore.tasks[indexPath.row]
        cell.configure(with: task.title, description: task.description)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataStore.tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
}

extension ToDoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ToDoViewController {
    
    func presentAlert(with message:String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        present(controller, animated: true, completion: nil)
    }
}

