//
//  CreateTaskVC.swift
//  TaskManager
//
//  Created by David Szemenkar on 2017-09-08.
//  Copyright © 2017 David Szemenkar. All rights reserved.
//

import UIKit

class CreateTaskVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var taskType: TaskType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
        taskTextView.delegate = self
    }
    @IBAction func shortTapped(_ sender: Any) {
        taskType = .shortTerm
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    @IBAction func longTapped(_ sender: Any) {
        taskType = .longTerm
        longTermButton.setSelectedColor()
        shortTermButton.setDeselectedColor()
    }

    @IBAction func nextTapped(_ sender: Any) {
        if taskTextView.text != "" && taskTextView.text !=  "What is your task?" {
            guard let finishTaskVC = storyboard?.instantiateViewController(withIdentifier: "finishTaskVC") as? FinishTaskVC else{ return }
            finishTaskVC.initData(description: taskTextView.text!, type: taskType)
            presentingViewController?.presentSecondary(finishTaskVC)
        }
    }

    @IBAction func backTapped(_ sender: Any) {
        dismissDetail()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        taskTextView.text = ""
        taskTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

}
