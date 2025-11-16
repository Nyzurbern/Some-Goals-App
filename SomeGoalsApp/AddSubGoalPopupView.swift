//
//  AddSubGoalPopupView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddSubGoalPopupView: View {
    @Environment(\.dismiss) private var dismiss
    var goalID: UUID
    var onAdd: (Subgoal) -> Void

    @State private var title: String = ""
    @State private var reward: Int = 10

    var body: some View {
        NavigationStack {
            Form {
                Section("Parent Goal") {
                    Text("Adding to selected goal")
                    Text("Reward: \(reward) coins")
                }
                Section("Details") {
                    TextField("What needs to be done?", text: $title)
                    Stepper("Reward: \(reward)", value: $reward, in: 0...1000)
                }
            }
            .navigationTitle("Add Sub-goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let sub = Subgoal(title: title.trimmingCharacters(in: .whitespacesAndNewlines), coinReward: reward)
                        onAdd(sub)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
