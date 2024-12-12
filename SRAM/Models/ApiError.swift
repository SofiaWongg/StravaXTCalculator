//
//  ApiError.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import Foundation

enum ApiError: LocalizedError { //TODO: fill these out!
  case invalidURL
  case unexpectedResponse
  case decodingFailed
  case httpError(statusCode: Int)
  case unknownError(error: Error)
  
  var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL provided"
    case .unexpectedResponse:
      return "Unexpected server response"
    case .decodingFailed:
      return "Failed to decode response"
    case .httpError(let statusCode):
      return "HTTP Error: \(statusCode)"
    case .unknownError(let error):
      return "Unknown error: \(error.localizedDescription)"
    }
  }
}
