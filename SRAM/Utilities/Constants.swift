//
//  Constants.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import Foundation

struct Constants {
  static let clientId = ProcessInfo.processInfo.environment["CLIENT_ID"] ?? "" //Stored in Env Var
  static let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? "" //Stored in Env Var
  static let redirectUri = "com.crosstrain.oauth" //If used with other parts (Bundle.main.bundleIdentifier ?? "")%3A%2F%2F\(Constants.redirectUri)
  static let scope = "activity:read"
  static let state = "test"
  
}
