//
//  FinishTaskVC.swift
//  TaskManager
//
//  Created by David Szemenkar on 2017-09-08.
//  Copyright © 2017 David Szemenkar. All rights reserved.
//

import UIKit
import CoreData

class FinishTaskVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createTaskButton: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var taskDescription: String!
    var taskType: TaskType!
    
    func initData(description: String, type: TaskType){
        self.taskDescription = description
        self.taskType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTaskButton.bindToKeyboard()
        pointsTextField.delegate = self
    }

    @IBAction func createTaskTapped(_ sender: Any) {
        if pointsTextField.text != ""{
        self.save { (complete) in
            if complete{
                dismiss(animated: true, completion: nil)
            }
        }
        }
    }
    @IBAction func backTapped(_ sender: Any) {
        dismissDetail()
    }

    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let task = Task(context: managedContext)
        
        task.taskDescription = taskDescription
        task.taskType = taskType.rawValue
        task.taskProgressValue = Int32(pointsTextField.text!)!
        task.taskCompletion = Int32(0)
        
        do{
           try managedContext.save()
            print("Successfully saved to CoreData")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
    }
}
