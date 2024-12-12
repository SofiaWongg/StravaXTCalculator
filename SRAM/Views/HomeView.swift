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
  
  @State private var weeklyMileage: [Date: [ActivityTypes: Double]] = [:]
  
  
    var body: some View {
      Group{
        if let loggedInUser = user, isLoggedIn{
          VStack{
            Text("Welcome back \(loggedInUser.athlete.firstname) \(loggedInUser.athlete.lastname)!")
            Text("Lets check out those stats")
            VStack{
              Text("Totals").bold()
              Text("Miles: \(toMiles(distanceInMeters: bikeMeters + runMeters + swimMeters))")
              Text("Converted Miles: XX.XX")
              HStack{
                VStack {
                  Text("Run")
                  Text("\(toMiles(distanceInMeters: runMeters)) mi").bold()
                }
                VStack {
                  Text("Ride")
                  Text("\(toMiles(distanceInMeters:bikeMeters)) mi").bold()
                }
                VStack {
                  Text("Swim")
                  Text("\(toMiles(distanceInMeters: swimMeters)) mi").bold()
                }
              } .padding()
            }
            
            Text("See conversions for:")
            HStack{
              Button("Ride"){}.background(.green).buttonStyle(.bordered)
              Button("Swim"){}.background(.yellow).buttonStyle(.bordered)
              Button("Run"){}.background(.cyan).buttonStyle(.bordered)
              
            }
            
            WeeklySnapshotView(weeklyMileage: weeklyMileage)
          

            Button("Sign out"){ //should actually deauthorize user: POST https://www.strava.com/oauth/deauthorize
              user = nil
              isLoggedIn = false
            }
            .buttonStyle(.bordered)
            
          }
        }else{
          ContentView()
        }
      }.onAppear(){
        Task {
          await loadActivities()
          getMileage()
          getSortedMileage()
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
      } catch {
          print("Error Fetching Activities: \(error)")
      }
  }
  
  private func getMileage()  {
    if activities.count != 0{
      var mileCount: [ActivityTypes: Double] = sortActivities(activities: activities)
      bikeMeters = mileCount[.ride] ?? 0.0
      runMeters = mileCount[.run] ?? 0.0
      swimMeters = mileCount[.swim] ?? 0.0
    }
}
  
  private func getSortedMileage() {
    if !activities.isEmpty {
      weeklyMileage = getMileageByWeek(activities: activities, weeks: 4)
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
