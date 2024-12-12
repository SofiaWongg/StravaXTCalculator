//
//  StravaActivityTypes.swift
//  SRAM
//
//  Created by Sofia Wong on 12/10/24.
//

import Foundation

//Strava Activity Types
//AlpineSki, BackcountrySki, Canoeing, Crossfit, EBikeRide, Elliptical, Golf, Handcycle, Hike, IceSkate, InlineSkate, Kayaking, Kitesurf, NordicSki, Ride, RockClimbing, RollerSki, Rowing, Run, Sail, Skateboard, Snowboard, Snowshoe, Soccer, StairStepper, StandUpPaddling, Surfing, Swim, Velomobile, VirtualRide, VirtualRun, Walk, WeightTraining, Wheelchair, Windsurf, Workout, Yoga

//Supported Types: Run, swim, ride

enum ActivityTypes: String {
  case run = "Run"
  case swim = "Swim"
  case ride = "Ride"
}
