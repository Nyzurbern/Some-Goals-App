//
//  BaseView 2.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 17/11/25.
//


import SwiftUI

struct BaseView: View {
    @EnvironmentObject var userData: UserData
    @State private var lastCollected: Int = 0
    @State private var showCollectedToast = false

    var body: some View {
        NavigationStack {
            VStack {
                header
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(userData.buildings) { b in
                            BuildingView(building: b).environmentObject(userData)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationTitle("Island Base")
            .toolbar {
                Button("Collect All") {
                    lastCollected = userData.collectAllBuildings()
                    if lastCollected > 0 {
                        showCollectedToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                            showCollectedToast = false
                        }
                    }
                }
            }
            .toast(isPresented: $showCollectedToast, message: lastCollected > 0 ? "+\(lastCollected) coins" : "No coins")
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Coins").font(.caption).foregroundColor(.secondary)
                Text("\(userData.coins)").font(.title).bold().foregroundStyle(.yellow)
            }
            Spacer()
            VStack {
                Text("Morale").font(.caption).foregroundColor(.secondary)
                Text("\(userData.morale)").bold()
            }
            Spacer()
            VStack {
                Text("Streak").font(.caption).foregroundColor(.secondary)
                Text("\(userData.streakDays)").bold()
            }
        }
        .padding()
    }
}
