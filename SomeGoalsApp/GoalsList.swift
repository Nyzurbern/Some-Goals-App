//
//  GoalsList.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 17/11/25.
//

import SwiftUI

struct GoalsListView: View {
    @EnvironmentObject var userData: UserData
    @State private var showAdd = false

    var sortedGoals: [Goal] {
        userData.goals.sorted { a, b in
            if a.status == b.status { return a.createdAt > b.createdAt }
            func rank(_ s: GoalStatus) -> Int {
                switch s {
                case .inProgress: return 4
                case .pending: return 3
                case .completed: return 2
                case .expired: return 1
                case .archived: return 0
                }
            }
            return rank(a.status) > rank(b.status)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Goals").font(.largeTitle).bold()
                    Spacer()
                    Button { showAdd = true } label: { Image(systemName: "plus.circle.fill").font(.title2) }
                }.padding()

                if userData.goals.isEmpty {
                    Text("No goals yet. Add one to start earning rewards.").foregroundColor(.secondary).padding()
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(sortedGoals) { g in
                                NavigationLink(destination: GoalDetailView(goalID: g.id).environmentObject(userData)) {
                                    GoalCardView(goal: g)
                                }
                            }
                        }.padding()
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                AddGoalPopupView { new in userData.addGoal(new); showAdd = false }.environmentObject(userData)
            }
        }
    }
}
