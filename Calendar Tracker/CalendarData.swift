//
//  CalendarData.swift
//  Calendar Tracker
//
//  Created by Dean Mollica on 17/2/18.
//  Copyright © 2018 Dean Mollica. All rights reserved.
//

import UIKit

enum AttendanceState {
    case present, halfDay, absent
}

struct CalendarData {
    var year: Int
    var month: Int
    var day: Int
    var attendance: AttendanceState
    
    var date: String {
        return "\(year)-\(month)-\(day)"
    }
}
