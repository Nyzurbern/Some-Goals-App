//
//  AddSubGoalPopupView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddSubGoalPopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedGoalId: UUID?
    @State private var title: String = ""
    @State private var reward: Int = 10
    
    private var availableGoals: [Goal] {
        userData.goals.filter { !$0.isCompleted }
    }
    
    private var selectedGoalIndex: Int? {
        guard let selectedId = selectedGoalId,
              let index = userData.goals.firstIndex(where: { $0.id == selectedId }) else {
            return nil
        }
        return index
    }
    
    var body: some View {
        NavigationStack {
            Form {
                if availableGoals.isEmpty {
                    ContentUnavailableView(
                        "How did you even reach this screen???",
                        systemImage: "plus.circle",
                        description: Text("Create a goal first to add sub-goals.")
                    )
                } else {
                    Section(header: Text("Parent Goal")) {
                        Picker("Select Goal", selection: $selectedGoalId) {
                            Text("Choose a goal").tag(nil as UUID?)
                            ForEach(availableGoals) { goal in
                                Text(goal.title)
                                    .tag(goal.id as UUID?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        if let selectedGoal = userData.goals.first(where: { $0.id == selectedGoalId }) {
                            Text("Deadline: \(selectedGoal.deadline, style: .date)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section(header: Text("Sub-goal Details")) {
                        TextField("What needs to be done?", text: $title)
                            .textInputAutocapitalization(.sentences)
                        
                        Text("Reward: \(reward) coins")
                    }
                    
                    if let goalIndex = selectedGoalIndex {
                        Section(header: Text("Current Sub-goals")) {
                            if userData.goals[goalIndex].subgoals.isEmpty {
                                Text("No sub-goals yet")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                            } else {
                                ForEach(userData.goals[goalIndex].subgoals) { subgoal in
                                    HStack {
                                        Image(systemName: subgoal.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(subgoal.isCompleted ? .green : .secondary)
                                        Text(subgoal.title)
                                        Spacer()
                                        Text("\(subgoal.coinReward) coins")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Sub-goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addSubGoal()
                    }
                    .disabled(!canAddSubGoal)
                }
            }
        }
    }
    
    private var canAddSubGoal: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedGoalId != nil
    }
    
    private func addSubGoal() {
        guard let goalId = selectedGoalId,
              let goalIndex = userData.goals.firstIndex(where: { $0.id == goalId }) else {
            return
        }
        
        let newSubGoal = Subgoal(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            coinReward: reward
        )
        
        userData.goals[goalIndex].subgoals.append(newSubGoal)
        dismiss()
    }
}
#Preview {
    AddSubGoalPopupView()
        .environmentObject(UserData(sample: true))
}
