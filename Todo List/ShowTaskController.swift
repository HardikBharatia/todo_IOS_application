//
//  ShowTaskController.swift
//  Todo List
//
//  Created by Ajit on 23/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
import EventKit

class ShowTaskController: UIViewController {
    
    var eventController: EventController!
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskPriority: UILabel!
    @IBOutlet weak var taskDate: UILabel!
    @IBOutlet weak var taskReminderTime: UILabel!

    override func viewDidLoad() {
        
        self.navigationItem.title = "Task Details"
        
        displayLabels()
    }
    
    func displayLabels() {
        
        let event = eventController!.singleEvent
        taskTitle.text = event!.title
        taskTitle.numberOfLines = 0;
        
        taskPriority.text = "Normal"
        taskPriority.numberOfLines = 0;
        
        let formatter = DateFormatter()
        formatter.dateFormat = "DD/MM/YY HH:mm a"
        taskDate.text = formatter.string(from: (event!.startDate)!)
        taskDate.numberOfLines = 0;
        
        if event!.hasAlarms {
            taskReminderTime.text = "Yes"
            taskReminderTime.numberOfLines = 0;
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? AddEditViewController {
            destinationViewController.eventController = eventController
        }
    }

}
