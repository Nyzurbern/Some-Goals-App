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
    @State private var newReflection = ""

    var body: some View {
        NavigationStack {
            VStack {
                if userData.goals.isEmpty {
                    Text("No goals yet").foregroundColor(.secondary).padding()
                    Spacer()
                } else {
                    Picker("Goal", selection: $selectedIndex) {
                        ForEach(userData.goals.indices, id: \.self) { i in
                            Text(userData.goals[i].title).tag(i)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    ScrollView {
                        VStack(alignment: .leading) {
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
                        let trimmed = newReflection.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        let goalID = userData.goals[selectedIndex].id
                        userData.addReflection(goalID: goalID, reflection: trimmed)
                        newReflection = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Reflections")
        }
    }
}
