//
//  WeeklySnapshotView.swift
//  SRAM
//
//  Created by Sofia Wong on 12/11/24.
//

import SwiftUI

struct WeeklySnapshotView: View {
  let weeklyMileage: [Date: [ActivityTypes: Double]]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      ForEach(weeklyMileage.keys.sorted(by: >), id: \.self) { weekStartDate in
        if let mileage = weeklyMileage[weekStartDate] {
          VStack(alignment: .leading, spacing: 8) {
            Text("Week of \(formatDate(weekStartDate))")
              .font(.headline)
            
            HStack {
              VStack {
                Text("Run")
                Text("\(toStringMiles(distanceInMeters: mileage[.run] ?? 0.0)) mi").bold()
              }
              .frame(maxWidth: .infinity)
              
              VStack {
                Text("Swim")
                Text("\(toStringMiles(distanceInMeters: mileage[.swim] ?? 0.0)) mi").bold()
              }
              .frame(maxWidth: .infinity)
              
              VStack {
                Text("Ride")
                Text("\(toStringMiles(distanceInMeters: mileage[.ride] ?? 0.0)) mi").bold()
              }
              .frame(maxWidth: .infinity)
            }
          }
        }
        Divider()
      }
    }
    .padding()
  }
}

#Preview {
  WeeklySnapshotView(weeklyMileage: [
    Date(): [
      .run: 5000.0,
      .swim: 2000.0,
      .ride: 10000.0
    ],
    Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!: [
      .run: 4500.0, 
        .swim: 1500.0,
      .ride: 9000.0
    ]
  ])
}
