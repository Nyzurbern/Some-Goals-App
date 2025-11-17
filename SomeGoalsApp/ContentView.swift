//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData(sample: false) // set true for sample data
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(userData)
            
            ReflectionView()
                .tabItem {
                    Label("Reflection", systemImage: "book.fill")
                }
                .environmentObject(userData)
            
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
                .environmentObject(userData)
        }
    }
}

#Preview {
    ContentView()
}

