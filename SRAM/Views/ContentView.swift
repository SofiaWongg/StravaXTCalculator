//
//  ContentView.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import SwiftUI

struct ContentView: View {
  private let stravaAPI = StravaAPI()
  @State private var isProcessingLogin = false
  @State private var isLoggedIn = false
  @State private var errorMessage: String?
  @State var loggedInUser: User?
  
  var body: some View {
    VStack {
      if isLoggedIn, let loggedInUser = loggedInUser{
        VStack{
          HomeView(isLoggedIn: $isLoggedIn, user: loggedInUser)
        }
        
      }
      else{
        VStack {
          if isProcessingLogin {
            ProgressView("Connecting to Strava...")
          } else {
            Image("stats")
              .resizable()
              .scaledToFit()
              .frame(width: 200.0, height: 200.0)
            Button("Connect to Strava"){
              isProcessingLogin = true
              Task {
                await auth()
              }
            }
            .buttonStyle(.bordered)
            
            if let errorMessage = errorMessage {
              Text(errorMessage)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .padding()
            }
          }
        }
      }
    }
    .padding()
  }
  
  private func auth() async {
    do {
      let code = try await stravaAPI.authenticate()
      let user = try await stravaAPI.getToken(code: code)
      
        self.isLoggedIn = true
        self.loggedInUser = user
        self.errorMessage = nil
      } catch {
      print("error during auth \(error)")
      self.errorMessage = "Authentication failed: \(error.localizedDescription)"
      errorMessage = "Auth failed: \(error.localizedDescription)"
    }
    isProcessingLogin = false
  }
}



#Preview {
  ContentView()
}
