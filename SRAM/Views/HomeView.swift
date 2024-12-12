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
  @State private var convertedBikeMiles: Double = 0.0
  @State private var convertedRunMiles: Double = 0.0
  @State private var convertedSwimMiles: Double = 0.0
  @State private var activities: [Activity] = []
  @State private var showType: ActivityTypes?
  @State private var convertedMileage: [Date: [ActivityTypes: Double]] = [:]
  @State private var weeklyMileage: [Date: [ActivityTypes: Double]] = [:]
  @State private var errorMessage: String?
  
  
  
  var body: some View {
    if let errorMessage = errorMessage {
      Text(errorMessage)
        .foregroundColor(.red)
        .multilineTextAlignment(.center)
        .padding()
    }
    Group{
      if let loggedInUser = user, isLoggedIn{
        
        
        VStack{
          Text("See conversions for:")
          
          SelectorView(showType: $showType)
          
          
          VStack{
            Text("Totals").bold()
            if let showType = showType{
              Text("Converted Miles: \(toStringMiles( distanceInMeters: convertedRunMiles+convertedBikeMiles+convertedSwimMiles))")
            }else{
              Text("Miles: \(toStringMiles(distanceInMeters: bikeMeters + runMeters + swimMeters))")
            }
            HStack{
              VStack {
                Text("Run")
                Text("\(toStringMiles(distanceInMeters: showType == nil ?  runMeters: convertedRunMiles))  mi").bold()
              }.frame(maxWidth: .infinity)
              VStack {
                Text("Ride")
                Text("\(toStringMiles(distanceInMeters: showType == nil ? bikeMeters : convertedBikeMiles )) mi").bold()
              }.frame(maxWidth: .infinity)
              VStack {
                Text("Swim")
                Text("\(toStringMiles(distanceInMeters: showType == nil ? swimMeters: convertedSwimMiles )) mi").bold()
              }.frame(maxWidth: .infinity)
            } .padding()
            
          }
          
          if let showType = showType {
            ScrollView{
              ChartView(convertedValues: $convertedMileage, targetType: showType) .frame(height: 300)
              WeeklySnapshotView(weeklyMileage: convertedMileage)
              Button("Sign out"){ //should actually deauthorize user: POST https://www.strava.com/oauth/deauthorize
                user = nil
                isLoggedIn = false
              }
              .buttonStyle(.bordered)
            }
          }
          else{
            WeeklySnapshotView(weeklyMileage: weeklyMileage)
            Button("Sign out"){ //should actually deauthorize user: POST https://www.strava.com/oauth/deauthorize
              user = nil
              isLoggedIn = false
            }
            .buttonStyle(.bordered)
            
          }
        }
      }else{
        ContentView()
      }
    }.onChange(of: showType) {
      if let showType = showType{
        convertedMileage = convertWeeklyMiles(weeklyMileage: weeklyMileage, targetType: showType)
      }
      getConvertedMileageTotals()
      
    }.onAppear(){
      Task {
        await loadActivities()
        getMileageTotals()
        getSortedMileage()
      }
    }
  }
  
  private func loadActivities() async {
    guard let accessToken = user?.access_token else {
      print("Access token not available")
      errorMessage = "Access token is not available."
      return
    }
    
    do {
      let fetchedActivities = try await stravaAPI.fetchActivities(accessToken: accessToken)
      activities = fetchedActivities
    } catch {
      print("Error Fetching Activities: \(error.localizedDescription)")
      errorMessage = "Error Fetching Activities: \(error.localizedDescription)"
    }
  }
  
  private func getMileageTotals()  {
    if activities.count != 0{
      var mileCount: [ActivityTypes: Double] = sortActivities(activities: activities)
      bikeMeters = mileCount[.ride] ?? 0.0
      runMeters = mileCount[.run] ?? 0.0
      swimMeters = mileCount[.swim] ?? 0.0
    }
  }
  
  private func getConvertedMileageTotals() {
    convertedRunMiles = 0
    convertedBikeMiles = 0
    convertedSwimMiles = 0
    for (_, activities) in convertedMileage {
      for (activityType, distanceInMeters) in activities {
        switch activityType {
        case .ride:
          convertedBikeMiles += distanceInMeters
        case .run:
          convertedRunMiles += distanceInMeters
        case .swim:
          convertedSwimMiles += distanceInMeters
        }
        
      }
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
