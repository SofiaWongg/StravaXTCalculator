//
//  DateUtils.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation


//Function to get epoch timestamp X weeks ago - for API Activity calls
func getEpochTimestamp(weeksAgo: Int = 4) -> Int {
    let weeksInSeconds = weeksAgo * 7 * 24 * 60 * 60
    let currentTime = Int(Date().timeIntervalSince1970)
    return currentTime - weeksInSeconds
}

