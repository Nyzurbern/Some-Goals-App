//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI
struct AddGoalPopupView: View {
    @Environment(\.dismiss) private var dismiss
    var onAdd: (Goal) -> Void
    @State private var title = ""
    @State private var description = ""
    @State private var deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    var body: some View {
        NavigationStack {
            Form {
                Section("Goal") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    DatePicker("Deadline", selection: $deadline, in: Date()..., displayedComponents: .date)
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let goal = Goal(title: title.trimmingCharacters(in: .whitespacesAndNewlines), description: description.trimmingCharacters(in: .whitespacesAndNewlines), deadline: deadline)
                        onAdd(goal)
                        dismiss()
                    }.disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
