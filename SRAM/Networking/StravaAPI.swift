//
//  StravaAPI.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import Foundation
import AuthenticationServices


class StravaAPI: NSObject, ASWebAuthenticationPresentationContextProviding {
  private var authSession: ASWebAuthenticationSession?
  
  public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    DispatchQueue.main.sync {
      return ASPresentationAnchor()//This must be run on main thread
    }
  }
  
  func authenticate() async throws -> String {
    let redirectUri = "\(Bundle.main.bundleIdentifier ?? "")%3A%2F%2F\(Constants.redirectUri)"
    
    guard let authUrl = URL(string: "https://www.strava.com/oauth/mobile/authorize" +
                            "?client_id=\(Constants.clientId)" +
                            "&redirect_uri=\(redirectUri)" +
                            "&response_type=code" +
                            "&approval_prompt=auto" +
                            "&scope=\(Constants.scope)" +
                            "&state=\(Constants.state)") else {
      throw ApiError.invalidURL
    }
    
    //converting callback func -> async await. Contiguation = completion of async op
    return try await withCheckedThrowingContinuation { continuation in
      authSession = ASWebAuthenticationSession(
        url: authUrl,
        callbackURLScheme: "com.crosstrain.oauth"
      ) {
        callbackURL, error in //TODO: why weak self here
        if let error = error {
          continuation.resume(throwing: error)
          return
        }
        
        guard let callbackURL = callbackURL,
              let components = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code"})?.value else{
          continuation.resume(throwing: URLError(.badServerResponse))
          
          return
        }
        continuation.resume(returning: code)
      }
      authSession?.presentationContextProvider = self
      authSession?.start()
    }
  }
  
  func getToken(code: String) async throws -> User{
    guard var urlComponents = URLComponents(string: "https://www.strava.com/api/v3/oauth/token") else {
      throw ApiError.invalidURL
    }
    
    urlComponents.queryItems = [URLQueryItem(name: "client_id", value: Constants.clientId),
                                URLQueryItem(name: "client_secret", value: Constants.clientSecret),
                                URLQueryItem(name: "code", value: code),
                                URLQueryItem(name: "grant_type", value: "authorization_code")]
    
    guard let url = urlComponents.url else {
      throw ApiError.invalidURL
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let (data, resp) = try await URLSession.shared.data(for: request)
    
    guard let httpResp = resp as? HTTPURLResponse else {
      throw ApiError.unexpectedResponse
    }
    
    switch httpResp.statusCode {
    case 200..<300:
      let decoder = JSONDecoder()
      let token = try decoder.decode(StravaToken.self, from: data)
      return User(response: token)
      
    default:
      print("Token request failed: \(httpResp.statusCode)")
      throw ApiError.unexpectedResponse
    }
  }
  
  func fetchActivities (accessToken: String) async throws -> [Activity] {
    let weeksAgo: Int = 4
    let pastTimestamp: Int = getEpochTimestamp(weeksAgo: weeksAgo)
    guard let activitiesURL = URL(string: "https://www.strava.com/api/v3/athlete/activities?after=\(pastTimestamp)") else {
      throw ApiError.invalidURL
    }
    
    var request = URLRequest(url: activitiesURL)
    
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    let (data, response) = try await URLSession.shared.data(for: request)
    
    if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
      throw ApiError.httpError(statusCode: httpResponse.statusCode)
    }
    
    let activities = try JSONDecoder().decode([Activity].self, from: data)
    return activities
  }
}
