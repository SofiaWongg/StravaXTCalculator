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
    
    //converting callback func -> async await
    return try await withCheckedThrowingContinuation { continuation in
      authSession = ASWebAuthenticationSession(
        url: authUrl,
        callbackURLScheme: "com.crosstrain.oauth"
      ) {
        [weak self] callbackURL, error in //TODO: why weak self here
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
  
  func getToken(code: String) async throws -> Result<User, Error> {
        let query = [URLQueryItem(name: "client_id", value: Constants.clientId),
                     URLQueryItem(name: "client_secret", value: Constants.clientSecret),
                     URLQueryItem(name: "code", value: code),
                     URLQueryItem(name: "grant_type", value: "authorization_code")]
        guard var urlComponents = URLComponents(string: "https://www.strava.com/api/v3/oauth/token") else {
          throw ApiError.invalidURL
        }
        urlComponents.queryItems = query
        guard let url = urlComponents.url else {
          fatalError("Malformed oauth token URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
          let (data, resp) = try await URLSession.shared.data(for: request)
          guard let resp = resp as? HTTPURLResponse else {
            let msg = "Unexpected non-http response type"
            assert(true, msg)
            return .failure(ApiError.unexpectedResponse)
          }
          switch resp.statusCode {
          case 200..<300:
            let decoder = JSONDecoder()
            let token = try decoder.decode(StravaToken.self, from: data)
            return .success(User(response: token))
            
          default:
            let msg = """
    Got error response for token api;status=\(resp.statusCode); \
    body=\(String(describing: String(data: data, encoding: .utf8)))
    """
            print(msg)
            return .failure(ApiError.unexpectedResponse)
          }
          //TODO: handle http response codes here
        } catch {
          let msg = "Token fetch failed with error=\(error)"
          print(msg)
          return .failure(ApiError.unexpectedResponse)
        }
  }
  
  func fetchActivities (accessToken: String) async throws -> [Activity] {
    var weeksAgo: Int = 4
    var pastTimestamp: Int = getEpochTimestamp(weeksAgo: weeksAgo)
    guard var activitiesURL = URL(string: "https://www.strava.com/api/v3/athlete/activities?after=\(pastTimestamp)") else {
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
