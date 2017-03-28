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
        tableView.estimatedRowHeight = 70.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let refresh = UIRefreshControl()
        
        tableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshData()
        
        DataStore.handler = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
}

extension ToDoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell") as! ToDoTableViewCell
        let todo = task(at: indexPath)
        cell.configure(with: todo.title, description: todo.description)
        
        return cell
    }
    
    func task(at indexPath:IndexPath) -> Task {
        switch indexPath.section {
        case 0:
            return DataStore.incompleteTasks[indexPath.row]
        case 1:
            return DataStore.completedTasks[indexPath.row]
        default:
            return DataStore.tasks[indexPath.row]
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return DataStore.incompleteTasks.count
        case 1:
            return DataStore.completedTasks.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Incomplete"
        case 1:
            return "Completed"
        default:
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Deleting from action")
            
            DataStore.deleteTask(at: indexPath) {
                tableView.deleteRows(at: [indexPath], with: .left)
                DataStore.shouldNotify = true
            }
        }
        
        guard indexPath.section == 0 else {
            return [delete]
        }
        
        let complete = UITableViewRowAction(style: .normal, title: "Complete") { action, indexPath in
        
            print("Completing")
            DataStore.completeTask(at: indexPath) { [weak self] in
                self?.refreshData()
            }
        }
        
        return [complete, delete]
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
    
    func refreshData() {
        DataStore.fetchAll() { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.refreshControl?.endRefreshing()
            }
            
        }
    }
}

