//
//  ReflectionView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct ReflectionView: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedIndex: Int = 0
    @State private var newReflection: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                if userData.goals.isEmpty {
                    Text("No goals yet. Add a goal from Home to start reflecting.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    Picker("Goal", selection: $selectedIndex) {
                        ForEach(userData.goals.indices, id: \.self) { idx in
                            Text(userData.goals[idx].title).tag(idx)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(userData.goals[selectedIndex].reflections, id: \.self) { r in
                                Text("• \(r)")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.07))
                                    .cornerRadius(8)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top)
                    }

                    TextEditor(text: $newReflection)
                        .frame(height: 120)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                        .padding()

                    Button("Add Reflection") {
                        let t = newReflection.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !t.isEmpty else { return }
                        let goal = userData.goals[selectedIndex]
                        userData.addReflection(goalID: goal.id, reflection: t)
                        newReflection = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Reflection Journal")
        }
    }
}
