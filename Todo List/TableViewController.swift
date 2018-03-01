//
//  ViewController.swift
//  Todo List
//
//  Created by Ajit on 20/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
import EventKit

class TableViewController: UITableViewController {
    
    var eventController =  EventController()

    @IBOutlet var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Set Navigation Buttons
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let rightEditBarButtonItem:UIBarButtonItem = self.editButtonItem
        self.navigationItem.setRightBarButtonItems([rightEditBarButtonItem,rightAddBarButtonItem], animated: true)
        
        eventController.fetchEvents()
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventController.fetchEvents()
      
        self.table.dataSource = self
        self.table.delegate = self
    }
    
    @objc func addTapped() {
        self.performSegue(withIdentifier: "changeseague", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventController.events?.count ?? 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "customCell") as? CustomTableViewCell) ??
                    (CustomTableViewCell(style: .default, reuseIdentifier: "customCell"))
        
        cell.taskTitle.text = "\(eventController.events![indexPath.row].title!)"
        cell.dateOfTask.text = "\(dateFormat("dd/MM/YY", eventController.events![indexPath.row].startDate!))"
        
        if (eventController.events![indexPath.row].alarms == nil) {
            cell.reminderIcon.isHidden = true
        }
        
        cell.priorityImage.image = setPriorityImage(eventController.events![indexPath.row].notes! )

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            do{
                try
                    eventController.eventStore.remove(eventController.events![indexPath.row], span: EKSpan.thisEvent, commit: true)
            } catch {
                print(error)
            }
            
            eventController.events!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventController.singleEvent = eventController.events![indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ShowTaskController {
            destinationViewController.eventController = eventController
        }
    }
    
    func setPriorityImage(_ priorityText: String) -> UIImage {
        var color = UIImage()
        switch priorityText {
        case "High":
            color = #imageLiteral(resourceName: "RedDot")
        case "Medium":
            color = #imageLiteral(resourceName: "GreenDot")
        case "Low":
            color = #imageLiteral(resourceName: "YellowDot")
        default:
            color = #imageLiteral(resourceName: "GreenDot")
        }
        return color
    }
    
    func dateFormat(_ format: String, _ date: Date ) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }

}
