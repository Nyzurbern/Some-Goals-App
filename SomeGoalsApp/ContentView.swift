//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData(sample: true)
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false

    var body: some View {
        Group {
            if hasSeenOnboarding {
                mainTabView
            } else {
                OnboardingView {
                    // Closure runs when user taps "Get Started"
                    hasSeenOnboarding = true
                }
                .environmentObject(userData)
            }
        }
        .onAppear { userData.appDidBecomeActive() }
    }

    private var mainTabView: some View {
        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .environmentObject(userData)

            BaseView()
                .tabItem { Label("Base", systemImage: "map.fill") }
                .environmentObject(userData)

            GoalsListView()
                .tabItem { Label("Goals", systemImage: "target") }
                .environmentObject(userData)

            ShopView()
                .tabItem { Label("Shop", systemImage: "cart.fill") }
                .environmentObject(userData)
        }
    }
}
