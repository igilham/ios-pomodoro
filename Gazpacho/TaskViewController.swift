//
//  TaskListViewController.swift
//  Gazpacho
//
//  Created by Ian Gilham on 20/08/2017.
//  Copyright © 2017 Ian Gilham. All rights reserved.
//

import Foundation
import UIKit

class TaskViewController : UITableViewController {
    
    private var tasks = Task.getMockData()
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_task", for: indexPath)
        
        if indexPath.row < tasks.count
        {
            let item = tasks[indexPath.row]
            cell.textLabel?.text = item.description
            
            let accessory: UITableViewCellAccessoryType = item.complete ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < tasks.count
        {
            let item = tasks[indexPath.row]
            item.complete = !item.complete
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < tasks.count
        {
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
    }
    
    func didTapAddTaskButton(_ sender: UIBarButtonItem)
    {
        // TODO: an alert is not really good enough for string plus number input.
        // Create an alert
        let alert = UIAlertController(
            title: "New task",
            message: "Insert a description and optional estimate for the new task:",
            preferredStyle: .alert)
        
        // Add user input fields to the alert
        alert.addTextField(configurationHandler: nil)
        alert.addTextField(configurationHandler: nil)
        
        // Add a "cancel" button to the alert. No handler required
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let description = alert.textFields?[0].text
            let estimate = alert.textFields?[1].text
            
            if description != nil {
                if let est = Int(estimate!) {
                    self.addNewTask(task: Task(description: description!, estimate: est))
                } else {
                    self.addNewTask(task: Task(description: description!))
                }
            }
            
//            if let description = alert.textFields?[0].text {
//                self.addNewTask(description: description)
//            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addNewTask(task: Task)
    {
        // The index of the new item will be the current item count
        let newIndex = tasks.count
        
        // Create new item and add it to the todo items list
        tasks.append(task)
        
        // Tell the table view a new row has been created
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TaskViewController.didTapAddTaskButton(_:)))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
