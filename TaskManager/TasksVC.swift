//
//  TasksVC.swift
//  TaskManager
//
//  Created by David Szemenkar on 2017-09-08.
//  Copyright © 2017 David Szemenkar. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class TasksVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects(){
        self.fetch { (complete) in
            if tasks.count >= 1{
                tableView.isHidden = false
            } else{
                tableView.isHidden = true
            }
        }
    }

    @IBAction func addTaskTapped(_ sender: Any) {
        guard let createTaskVC = storyboard?.instantiateViewController(withIdentifier: "CreateTaskVC") else{
            return
        }
        presentDetail(createTaskVC)
    }

}

extension TasksVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell else{return UITableViewCell()}
        
        let task = tasks[indexPath.row]
        
        cell.configureCell(task: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            self.removeTask(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.4325117383, blue: 0.3432344314, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        return [deleteAction, addAction]
    }
}

extension TasksVC{
    func setProgress(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenTask = tasks[indexPath.row]
        
        if chosenTask.taskCompletion < chosenTask.taskProgressValue {
            chosenTask.taskCompletion = chosenTask.taskCompletion + 1
        } else{
            return
        }
        
        do{
            try managedContext.save()
            print("Set progress successfully")
        } catch{
            debugPrint("Could not set progress \(error.localizedDescription)")
        }
    }
    
    func removeTask(atIndexPath indexPath: IndexPath){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        managedContext.delete(tasks[indexPath.row])
        
        do{
            try managedContext.save()
            print("Removed object succesfully")
        } catch{
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        do {
           tasks = try managedContext.fetch(fetchRequest) as! [Task]
            completion(true)
        } catch{
            debugPrint("Could not fetch \(error.localizedDescription)")
            completion(false)
        }
        
    }
}
