//
//   CalenderModel.swift
//  Todo List
//
//  Created by Ajit on 21/02/18.
//  Copyright © 2018 Hardik. All rights reserved.
//

import Foundation
import EventKit

class TodoModel {
    var task: String = "Nothing"
    var priority: String = "Low"
    var date: Date?
    var reminder: Bool = false
    var time: String = "01:00 AM"
}
