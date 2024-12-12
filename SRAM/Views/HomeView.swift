//
//  HomeView.swift
//  SRAM
//
//  Created by Sofia Wong on 12/8/24.
//

import SwiftUI

struct HomeView: View {
  private let stravaAPI = StravaAPI()
  @Binding var isLoggedIn: Bool
  @State var user: User?
  @State private var bikeMeters: Double = 0.0
  @State private var runMeters: Double = 0.0
  @State private var swimMeters: Double = 0.0
  @State private var activities: [Activity] = []
  
    var body: some View {
      Group{
        if let loggedInUser = user, isLoggedIn{
          VStack{
            Text("Welcome back \(loggedInUser.athlete.firstname) \(loggedInUser.athlete.lastname)!")
            Text("Lets check out those stats")
            Text("Total Miles Biked: \(toMiles(distanceInMeters:bikeMeters))")
            Text("Total Miles Run: \(toMiles(distanceInMeters: runMeters))")
            Text("Total Miles Swum: \(toMiles(distanceInMeters:swimMeters))")
            
            Text("See conversions for:")
            HStack{
              Button("Bike"){}.background(.green).buttonStyle(.bordered)
              Button("Swim"){}.background(.yellow).buttonStyle(.bordered)
              Button("Run"){}.background(.cyan).buttonStyle(.bordered)
              
            }

            Button("Sign out"){ //should actually deauthorize user: POST https://www.strava.com/oauth/deauthorize
              user = nil
              isLoggedIn = false
            }
            .buttonStyle(.bordered)
            
            //Remove this later
            List(activities, id: \.id) { activity in
              Text("\(activity.type) - \(Int(activity.distance/1609)) miles in \(activity.moving_time/60) minutes")
                                }
          }
        }else{
          ContentView()
        }
      }.onAppear(){
        Task {
          await loadActivities()
          getMileage()
        }
      }
    }
  
  
  private func loadActivities() async {
      guard let accessToken = user?.accessToken else {
          print("Access token not available")
          return
      }
      
      do {
          let fetchedActivities = try await stravaAPI.fetchActivities(accessToken: accessToken)
          activities = fetchedActivities
          print("Fetched Activities: \(activities)")
      } catch {
          print("Error Fetching Activities: \(error)")
      }
  }
  
  private func getMileage()  {
    if activities.count != 0{
      var mileCount: [ActivityTypes: Double] = sortActivities(activities: activities)
      bikeMeters = mileCount[.bike] ?? 0.0
      runMeters = mileCount[.run] ?? 0.0
      swimMeters = mileCount[.swim] ?? 0.0
    }
}



}



//struct HomeViewPreviewWrapper: View {
//    @State private var isLoggedIn = true
//    @State private var user = User.previewUser
//
//    var body: some View {
//        HomeView(
//          isLoggedIn: isLoggedIn,
//            user: user,
//            bikeMiles: 50,
//            runMiles: 20
//        )
//    }
//}
//
//#Preview {
//  HomeViewPreviewWrapper()
//}
