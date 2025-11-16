//
//  HomeView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case addGoal, addSubgoalFor(UUID), dueDatePopupFor(UUID)
    var id: String {
        switch self {
        case .addGoal: return "addGoal"
        case .addSubgoalFor(let id): return "addSub:\(id)"
        case .dueDatePopupFor(let id): return "due:\(id)"
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @State private var activeSheet: ActiveSheet?

    var overallProgress: Double {
        guard !userData.goals.isEmpty else { return 0.0 }
        let sum = userData.goals.reduce(0.0) { $0 + $1.progressFraction }
        return sum / Double(userData.goals.count)
    }

    var body: some View {
        NavigationStack {
            VStack {
                header
                actionRow
                goalList
            }
            .navigationTitle("My Goals")
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addGoal:
                    AddGoalPopupView { newGoal in
                        userData.addGoal(newGoal)
                        activeSheet = nil
                    }
                    .environmentObject(userData)
                case .addSubgoalFor(let goalID):
                    AddSubGoalPopupView(goalID: goalID) { newSub in
                        userData.addSubgoal(to: goalID, subgoal: newSub)
                        activeSheet = nil
                    }
                    .environmentObject(userData)
                case .dueDatePopupFor(let goalID):
                    DueDatePopupView(goalID: goalID)
                        .environmentObject(userData)
                }
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Coins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(userData.coins)")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.yellow)
                }
                Spacer()
                VStack(alignment: .leading) {
                    Text("Overall Progress")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        ProgressView(value: overallProgress)
                            .frame(width: 160, height: 10)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        Text("\(Int(overallProgress * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }

    private var actionRow: some View {
        HStack {
            Button {
                activeSheet = .addGoal
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
    }

    private var goalList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(userData.goals.indices, id: \.self) { idx in
                    let goal = userData.goals[idx]
                    VStack {
                        HStack {
                            NavigationLink(destination: GoalDetailView(goalID: goal.id).environmentObject(userData)) {
                                GoalCardView(goal: goal)
                            }
                        }
                        HStack {
                            Button("Add sub-goal") {
                                activeSheet = .addSubgoalFor(goal.id)
                            }
                            Spacer()
                            if goal.isOverdue {
                                Button("Due actions") {
                                    activeSheet = .dueDatePopupFor(goal.id)
                                }
                                .tint(.red)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView().environmentObject(UserData(sample: true))
}
