//
//  ChartView.swift
//  SRAM
//
//  Created by Sofia Wong on 12/12/24.
//

import SwiftUI
import Charts

struct ChartView: View {
  @Binding var convertedValues: [Date: [ActivityTypes: Double]]
  var targetType: ActivityTypes
  
    var body: some View {
        Chart {
            ForEach(convertedValues.keys.sorted(), id: \.self) { date in
                if let activities = convertedValues[date] {
                  ForEach(Array(activities.keys), id: \.self) { activityType in
                      if let miles = (activities[activityType]) {
                        BarMark(
                            x: .value("Date", formatDateShort(date)),
                            y: .value("Miles", toMiles(distanceInMeters: miles)),
                            width: .fixed(30)
                        )
                        .foregroundStyle(color(activityType: activityType))
                        .cornerRadius(8)
                      }
                  }
                } 
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 4))
        }
        .chartYAxis {
          AxisMarks()
        }
        .chartXAxisLabel("Week of")
        .chartYAxisLabel("Miles")
        .padding()
    }
  
  private func color(activityType: ActivityTypes) -> Color {
          switch activityType {
          case .run:
              return .blue
          case .ride:
              return .green
          case .swim:
              return .orange
          }
      }
}

//#Preview {
//    ChartView(
//        convertedValues: [
//            Date(): [.run: 10.5, .ride: 25.0, .swim: 5.0],
//            Date().addingTimeInterval(-86400): [.run: 12.0, .ride: 20.0, .swim: 7.0]
//        ]
//    )
//}
