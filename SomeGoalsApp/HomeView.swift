//
//  HomeView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct GoalIDWrapper: Identifiable {
    let id: UUID
}

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @State private var activeGoalToInspect: GoalIDWrapper?
    @State private var showCompleted = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    header
                    missionsSection
                    goalsSection
                    islandSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Island of Progress")
            .sheet(item: $activeGoalToInspect) { wrapper in
                GoalDetailView(goalID: wrapper.id) {
                    activeGoalToInspect = nil
                }
                .environmentObject(userData)
            }
        }
    }
}

// MARK: - Header (Coins / XP / Morale)
extension HomeView {
    private var header: some View {
        HStack(spacing: 24) {
            statBlock(title: "Coins", value: "\(userData.coins)", color: .yellow)
            statBlock(title: "XP", value: "\(userData.xp)", color: .blue)
            statBlock(title: "Morale", value: "\(userData.morale)", color: .green)
            Spacer()
        }
        .padding(.horizontal)
    }

    private func statBlock(title: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.title3)
                .bold()
                .foregroundStyle(color)
        }
    }
}

//Missions
extension HomeView {
    private var missionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Missions")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(userData.dailyMissions) { m in
                        VStack(spacing: 6) {
                            Text(m.title)
                                .font(.caption)
                                .fontWeight(.semibold)

                            Text(m.isCompletedToday ? "Done" : "\(m.rewardCoins)⍟")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Button("Claim") {
                                userData.completeDailyMission(m.id)
                            }
                            .buttonStyle(.bordered)
                            .disabled(m.isCompletedToday)
                        }
                        .padding(10)
                        .frame(width: 120)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

//Goals
extension HomeView {
    private var goalsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(showCompleted ? "Completed Goals" : "Active Goals")
                    .font(.headline)
                Spacer()

                Picker("", selection: $showCompleted) {
                    Text("Active").tag(false)
                    Text("Completed").tag(true)
                }
                .pickerStyle(.segmented)
                .frame(width: 180)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(userData.goals.filter {
                        showCompleted ? $0.status == .completed : $0.status != .completed
                    }) { g in
                        GoalCardView(goal: g)
                            .onTapGesture {
                                activeGoalToInspect = GoalIDWrapper(id: g.id)
                            }
                    }

                    if !showCompleted {
                        addGoalButton
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var addGoalButton: some View {
        Button {
            print("Add Goal Popup")
        } label: {
            VStack(spacing: 6) {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                Text("Add Goal")
                    .font(.caption2)
            }
            .frame(width: 140, height: 120)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

//Island Section
extension HomeView {
    private var islandSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your Island")
                    .font(.headline)
                Spacer()
                Button("Collect All") {
                    _ = userData.collectAllBuildings()
                }
                .buttonStyle(.borderedProminent)
                .font(.caption)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(userData.buildings) { b in
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 130, height: 90)
                                .overlay(
                                    Text(b.type.displayName)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 6)
                                )

                            Text("Lv \(b.level)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 130)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }

                    buyButton
                }
                .padding(.horizontal)
            }
        }
    }

    private var buyButton: some View {
        Button {
            print("Open Shop")
        } label: {
            VStack(spacing: 6) {
                Image(systemName: "plus.circle")
                    .font(.largeTitle)
                Text("Buy")
                    .font(.caption2)
            }
            .frame(width: 130, height: 120)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}
