//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Franco Rodrigues on 1/20/22.
//

import SwiftUI

@main
struct LandmarksApp: App {
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }
    }
}
