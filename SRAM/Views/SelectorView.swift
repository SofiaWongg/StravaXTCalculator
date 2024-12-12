//
//  SelectorView.swift
//  SRAM
//
//  Created by Sofia Wong on 12/12/24.
//

import SwiftUI

struct SelectorView: View {
  @Binding var showType: ActivityTypes?
  
  var body: some View {
    HStack{
      Button(action: { showType = nil }) {
        VStack {
          Text("All")
            .font(.headline)
            .foregroundColor(showType == nil ? .white : .black)
        }
        .padding()
        .background(showType == nil ? Color.gray : Color.clear)
        .cornerRadius(10)
      }
      Button(action: { showType = .ride }) {
        VStack {
          Image(systemName: "bicycle")
            .resizable()
            .scaledToFit()
            .foregroundColor(showType == .ride ? .white : .black)
        }
        .padding()
        .background(showType == .ride ? Color.green : Color.clear)
        .cornerRadius(10)
      }
      Button(action: { showType = .swim }) {
        VStack {
          Image(systemName: "figure.open.water.swim")
            .resizable()
            .scaledToFit()
            .foregroundColor(showType == .swim ? .white : .black)
        }
        .padding()
        .background(showType == .swim ? Color.orange : Color.clear)
        .cornerRadius(10)
      }
      
      // "Run" Button
      Button(action: { showType = .run }) {
        VStack {
          Image(systemName: "figure.run")
            .resizable()
            .scaledToFit()
            .foregroundColor(showType == .run ? .white : .black)
        }
        .padding()
        .background(showType == .run ? Color.blue : Color.clear)
        .cornerRadius(10)
      }
    }
    .frame(height: 60)
  }
}

#Preview {
  SelectorView(showType: .constant(.ride))
}
