//
//  FailedGoalView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct FailOrSuccessView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    let goalID: UUID
    @State private var reflection = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Write a short reflection to complete this goal").font(.headline).multilineTextAlignment(.center)
                TextEditor(text: $reflection).frame(height: 140).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                Button("Submit & Complete") {
                    let t = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !t.isEmpty else { return }
                    userData.addReflection(goalID: goalID, reflection: t)
                    if let g = userData.goals.first(where: { $0.id == goalID }) {
                        userData.markGoalCompleted(goalID, beforeDeadlineBonus: Date() <= g.deadline)
                    }
                    dismiss()
                }.buttonStyle(.borderedProminent).disabled(reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                Spacer()
            }.padding().navigationTitle("Complete Goal")
        }
    }
}
