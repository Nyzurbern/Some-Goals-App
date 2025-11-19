//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData(sample: false) // set true for sample data
    @Binding var Reflection: Reflection
    
    var body: some View {
        TabView {
            HomeView( Reflection: $Reflection)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(userData)
            
            ReflectionArchive()
                .tabItem {
                    Label("Archive", systemImage: "book.fill")
                }
                .environmentObject(userData)
        }
    }
}
//
//#Preview {
//    ContentView()
//}
//
