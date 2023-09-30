//
//  SwiftUI_WeatherApp.swift
//  SwiftUI-Weather
//
//  Created by Gangadhar C on 9/26/23.
//

import SwiftUI

@main
struct SwiftUI_WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(Location: .constant("chennai"))
        }
    }
}
