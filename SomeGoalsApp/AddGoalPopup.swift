//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddGoalPopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var deadline: Date = Date()
    @State private var reward: Int = 50 
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Short description", text: $description)
                        .textInputAutocapitalization(.sentences)
                    DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                }
                
                Section(header: Text("Reward")) {
                    Text("Coin reward: \(reward)")
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let g = Goal(title: title, description: description, deadline: deadline, subgoals: [], reflections: [])
                        userData.goals.append(g)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddGoalPopupView()
        .environmentObject(UserData(sample: true))
}
