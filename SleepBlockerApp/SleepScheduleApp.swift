//
//  SleepScheduleApp.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/4/24.
//

import Foundation
import FamilyControls
import SwiftData


@Model
class SleepSchedule { // a new instance is created everytime something changes
    var startTime: Date
    var endTime: Date
    var selectionToDiscourage: FamilyActivitySelection
    var daysActive: [String]
    var notifyTime: Int
    
    init(startTime: Date, endTime: Date, selectionToDiscourage: FamilyActivitySelection, daysActive: [String], notifyTime: Int) {
        self.startTime = startTime
        self.endTime = endTime
        self.selectionToDiscourage = selectionToDiscourage
        self.daysActive = daysActive
        self.notifyTime = notifyTime
    }
}
