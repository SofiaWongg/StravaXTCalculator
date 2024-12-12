//
//  Activity.swift
//  SRAM
//
//  Created by Sofia Wong on 12/9/24.
//

import Foundation

struct Activity: Codable{
  let id: Int
  let name: String
  let moving_time: Int //seconds
  let type: String
  let distance: Double //meters
}
