//
//  EventController.swift
//  Todo List
//
//  Created by Ajit on 23/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import Foundation
import EventKit

class EventController: NSObject{
    
    let eventStore : EKEventStore = EKEventStore()
    var events: [EKEvent]?
    var singleEvent: EKEvent?
    
    func fetchEvents() {
        
        let calendarTitle = eventStore.defaultCalendarForNewEvents?.title
        let calendars = eventStore.calendars(for: .event)
        
        for calendar: EKCalendar in calendars {
            
            if calendar.title == calendarTitle {
                let selectedCalendar = calendar
                
                let startDate = Date(timeIntervalSinceNow: -60*60*24)
                let endDate = Date(timeIntervalSinceNow: 60*60*24*30*12)
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [selectedCalendar])
                events = eventStore.events(matching: predicate) as [EKEvent]
                
                for event in events! {
                    print("Event Title : \(event.title) Event ID: \(event.eventIdentifier)")
                }
                
            }
        }
    }
    
}
