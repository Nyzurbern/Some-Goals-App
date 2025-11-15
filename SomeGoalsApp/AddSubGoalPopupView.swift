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
    
    @State private var selectedIndex: Int = 0
    @State private var title: String = ""
    @State private var reward: Int = 10
    
    var body: some View {
        NavigationStack {
            Form {
                if userData.goals.isEmpty {
                    Text("Add a goal first to attach sub-goals.")
                        .foregroundColor(.secondary)
                } else {
                    Section(header: Text("Parent Goal")) {
                        Picker("Goal", selection: $selectedIndex) {
                            ForEach(userData.goals.indices, id: \.self) { idx in
                                Text(userData.goals[idx].title).tag(idx)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section(header: Text("Sub-goal")) {
                        TextField("Title", text: $title)
                        Stepper("Reward: \(reward) coins", value: $reward, in: 0...200)
                    }
                }
            }
            .navigationTitle("Add Sub-goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !userData.goals.isEmpty else { return }
                        let s = Subgoal(title: title, coinReward: reward)
                        userData.goals[selectedIndex].subgoals.append(s)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || userData.goals.isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddSubGoalPopupView()
        .environmentObject(UserData(sample: true))
}
