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
    
    private var tasks: [Task] = [Task]()
    
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
            cell.textLabel?.text = item.title
            
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
    
    @objc
    public func applicationDidEnterBackground(_ notification: NSNotification) {
        do {
            try tasks.writeToPersistence()
        }
        catch let error {
            NSLog("Error writing to persistence: \(error)")
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
            let title = alert.textFields?[0].text
            let estimate = alert.textFields?[1].text
            
            if title != nil {
                if let est = Int(estimate!) {
                    self.addNewTask(task: Task(title: title!, estimate: est))
                } else {
                    self.addNewTask(task: Task(title: title!))
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
        NSLog("View loaded - initialising app data")
        self.title = "Tasks"
        
        // Add an 'Add' button to the task list view
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TaskViewController.didTapAddTaskButton(_:)))
        
        // Setup a notification to let us know when the app is about to close,
        // and that we should store the user items to persistence. This will call the
        // applicationDidEnterBackground() function in this class
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UIApplicationDelegate.applicationDidEnterBackground(_:)),
            name: NSNotification.Name.UIApplicationDidEnterBackground,
            object: nil)
        
        do {
            // Try to load from persistence
            NSLog("Attempting to load persistent data")
            self.tasks = try [Task].readFromPersistence()
        }
        catch let error as NSError {
            if error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
                NSLog("No persistence file found, not necesserially an error...")
            } else {
                let alert = UIAlertController(
                    title: "Error",
                    message: "Could not load the stored tasks!",
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                NSLog("Error loading from persistence: \(error)")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
