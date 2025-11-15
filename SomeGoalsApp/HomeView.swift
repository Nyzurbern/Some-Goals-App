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
    var overallProgress: Double {
        guard !userData.goals.isEmpty else { return 0.0 }
        let sum = userData.goals.reduce(0.0) { $0 + $1.progress }
        return sum / Double(userData.goals.count)
    }
    
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
                            
                            VStack(alignment: .leading) {
                                Text("Overall Progress")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                HStack {
                                    ProgressView(value: overallProgress)
                                        .frame(height: 8)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .frame(width: 160)
                                    Text("\(Int(overallProgress * 100))%")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
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
                    
                    Button {
                        showAddSubGoal = true
                    } label: {
                        Label("Add Sub-goal", systemImage: "plus.circle")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                // goal list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(userData.goals.indices, id: \.self) { idx in
                            let goal = userData.goals[idx]
                            NavigationLink {
                                BigGoalCharacterView()
                            } label: {
                                Image(goal.character.image)
                            }
                            NavigationLink {
                                // pass binding to the goal so edits apply to list
                                GoalDetailView(goal: $userData.goals[idx])
                                    .environmentObject(userData)
                            } label: {
                                GoalCardView(goal: goal)
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
