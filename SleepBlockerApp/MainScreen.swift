//
//  MainScreen.swift
//  SleepBlockerApp
//
//  Created by Saketh Koona on 8/4/24.
//

import SwiftUI

struct MainScreen : View {
    var body: some View {
        TabView {
            SchedulingView(from: .now, to: .now)
                .tabItem {
                    Text("Home Page")
                }
            
            AnalyticsView()
                .tabItem {
                    Text("Statistics")
                }
        }
    }
}
