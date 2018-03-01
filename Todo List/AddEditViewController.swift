//
//  AddDeleteViewController.swift
//  Todo List
//
//  Created by Ajit on 20/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import UIKit
import EventKit

class AddEditViewController: UIViewController {
    
    var eventController = EventController()
    
    var time: String = "01:00 AM"
    

    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskPriority: UITextField!
    @IBOutlet weak var taskDate: UIDatePicker!
    @IBOutlet weak var taskReminderSwitch: UISwitch!
    @IBOutlet weak var taskReminderTime: UIDatePicker!
    
    override func viewWillAppear(_ animated: Bool) {
        askForPermission()
        
        if eventController.singleEvent != nil {
            title = "EDIT"
        } else {
            title = "ADD"
        }
        
        self.navigationItem.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskDate.datePickerMode = UIDatePickerMode.date
        taskReminderTime.datePickerMode = UIDatePickerMode.time
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onToggle(_ sender: UISwitch) {
        if(taskReminderSwitch.isOn) {
            taskReminderTime.isHidden = false
            time = dateFormat("HH:mm a", taskReminderTime.date)
        } else {
            taskReminderTime.isHidden = true
        }
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        
        let newEvent:EKEvent = EKEvent(eventStore: eventController.eventStore)
        
        if eventController.singleEvent != nil {
            editEvent(eventController.singleEvent!)
        } else {
            addEvent(newEvent)
        }
    }
    
    func addEvent(_ event: EKEvent) {
        event.title = taskTitle.text!
        event.startDate = taskDate.date
        event.endDate = taskDate.date
        event.notes = taskPriority.text!
        event.calendar = eventController.eventStore.defaultCalendarForNewEvents
        
        if(taskReminderSwitch.isOn) {
            event.addAlarm(EKAlarm(relativeOffset: -5.0))
        }
        else {
            if event.hasAlarms {
                event.removeAlarm(EKAlarm())
            }
        }
        
        do {
            try eventController.eventStore.save(event, span: .thisEvent, commit: true)
        } catch {
            showAlert(_title: "Storage Error", "Event Not Stored", "Try Again")
        }
        
        print("Event saved")
    }

    func editEvent(_ currentEvent: EKEvent) {
        
        let calendarTitle = eventController.eventStore.defaultCalendarForNewEvents?.title
        let calendars = eventController.eventStore.calendars(for: .event)
        
        for calendar: EKCalendar in calendars {
            
            if calendar.title == calendarTitle {
                let selectedCalendar = calendar
                
                let startDate = Date(timeIntervalSinceNow: -60*60*24)
                let endDate = Date(timeIntervalSinceNow: 60*60*24*30*12)
                let predicate = eventController.eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [selectedCalendar])
                eventController.events! = eventController.eventStore.events(matching: predicate) as [EKEvent]
                
                for event in eventController.events! {
                    if currentEvent.eventIdentifier == event.eventIdentifier {
                        addEvent(event)
                    }
                }
            }
        }
    }
    
    func askForPermission(){
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            // Things are in line with being able to show the calendars in the table view
            viewDidLoad()
            //refreshTableView()
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            
            let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: { (success) in})
            //needPermissionView.fadeIn()
        }
    }
    
    func requestAccessToCalendar() {
        EKEventStore().requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.viewDidLoad()
                    //self.refreshTableView()
                })
            } else {
                DispatchQueue.main.async(execute: {
                    let openSettingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                    UIApplication.shared.open(openSettingsUrl!, options: [:], completionHandler: { (success) in})
                })
            }
        })
    }
    
    
    func showAlert(_title: String,_ message: String,_ actionTitle: String) {
        
        let alertController = UIAlertController(title: _title, message: message, preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)

    }
    
    func dateFormat(_ format: String, _ date: Date ) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}
