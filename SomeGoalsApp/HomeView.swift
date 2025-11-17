//
//  HomeView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @State private var showAddGoal = false
    @State private var showAddSubGoal = false
    
    // overall progress across goals
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                // Header + summary
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My Goals")
                            .font(.largeTitle)
                            .bold()
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Coins")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(userData.coins)")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(.yellow)
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                // actions
                HStack(spacing: 12) {
                    Button {
                        showAddGoal = true
                    } label: {
                        Label("Add Goal", systemImage: "plus.circle.fill")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
                            .foregroundStyle(.white)
                    }
                    
                   
                    Spacer()
                }
                .padding(.horizontal)
                
                // goal list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(userData.goals.indices, id: \.self) { idx in
                            NavigationLink {
                                // pass binding to the goal so edits apply to list
                                GoalDetailView(goal: $userData.goals[idx])
                                    .environmentObject(userData)
                            } label: {
                                GoalCardView(goal: userData.goals[idx])
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .sheet(isPresented: $showAddGoal) {
                AddGoalPopupView()
                    .environmentObject(userData)
            }
            .sheet(isPresented: $showAddSubGoal) {
                AddSubGoalPopupView()
                    .environmentObject(userData)
            }
        }
    }
}

#Preview {
    HomeView().environmentObject(UserData(sample: true))
}

