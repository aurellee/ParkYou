//
//  ParkYouApp.swift
//  ParkYou Watch App
//
//  Created by Jaqueline Aurelia Langi on 27/05/24.
//

import SwiftUI


@main
struct ParkYouApp: App {
    @StateObject private var beaconManager = BeaconDirection()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(beaconManager)
        }
    }
}
