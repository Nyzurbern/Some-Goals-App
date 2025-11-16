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
    @State private var reflectionText: String = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Write a short reflection about completion")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                TextEditor(text: $reflectionText)
                    .frame(height: 140)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                Button("Submit & Mark Complete") {
                    userData.addReflection(goalID: goalID, reflection: reflectionText)
                    userData.markGoalCompleted(goalID)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .disabled(reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle("Complete Goal")
        }
    }
}
