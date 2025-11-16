//
//  GoalDetail.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct GoalDetailView: View {
    @EnvironmentObject var userData: UserData
    let goalID: UUID

    // local editable copies for text fields; write back via userData.updateGoal
    @State private var newReflection: String = ""
    @State private var showConfirmComplete: Bool = false

    private var goalIndex: Int? {
        userData.goals.firstIndex(where: { $0.id == goalID })
    }

    private var bindingGoal: Goal? {
        guard let idx = goalIndex else { return nil }
        return userData.goals[idx]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let goal = bindingGoal {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        TextField("Title", text: Binding(
                            get: { goal.title },
                            set: { newVal in
                                var g = goal
                                g.title = newVal
                                userData.updateGoal(g)
                            }))
                            .font(.title2.bold())

                        // Description
                        TextField("Short description", text: Binding(
                            get: { goal.description },
                            set: { newVal in
                                var g = goal
                                g.description = newVal
                                userData.updateGoal(g)
                            }))
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        // Deadline
                        HStack {
                            Text("Deadline:")
                            Spacer()
                            DatePicker("", selection: Binding(
                                get: { goal.deadline },
                                set: { newVal in
                                    var g = goal
                                    g.deadline = newVal
                                    userData.updateGoal(g)
                                }), displayedComponents: .date)
                                .datePickerStyle(.compact)
                        }

                        // Progress
                        VStack(alignment: .leading) {
                            Text("Progress")
                                .font(.headline)
                            ProgressView(value: goal.progressFraction)
                                .frame(height: 12)
                            Text(goal.percentString).font(.caption).foregroundColor(.secondary)
                        }

                        // Sub-goals (iterate by object, not indices)
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Sub-goals")
                                    .font(.headline)
                                Spacer()
                                // Ideally show the Home sheet to add - fallback is noop
                                Button("Add") {
                                    // No-op: HomeView handles creation flow via sheet
                                }
                            }

                            ForEach(goal.subgoals, id: \.id) { sub in
                                HStack {
                                    Button {
                                        userData.toggleSubgoalCompletion(goalID: goal.id, subgoalID: sub.id)
                                    } label: {
                                        Image(systemName: sub.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(sub.isCompleted ? .green : .primary)
                                    }

                                    // Update title via UserData API
                                    TextField("Subgoal", text: Binding(
                                        get: { sub.title },
                                        set: { newVal in
                                            userData.updateSubgoalTitle(goalID: goal.id, subgoalID: sub.id, newTitle: newVal)
                                        }))

                                    Spacer()

                                    Button {
                                        userData.removeSubgoal(goalID: goal.id, subgoalID: sub.id)
                                    } label: {
                                        Image(systemName: "trash").foregroundColor(.red)
                                    }
                                }
                                .padding(8)
                                .background(Color.gray.opacity(0.06))
                                .cornerRadius(8)
                            }
                        }

                        // Reflections
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reflections")
                                .font(.headline)
                            ForEach(goal.reflections, id: \.self) { r in
                                Text("• \(r)")
                                    .padding(8)
                                    .background(Color.gray.opacity(0.07))
                                    .cornerRadius(8)
                            }

                            TextEditor(text: $newReflection)
                                .frame(height: 120)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                            Button("Add Reflection") {
                                userData.addReflection(goalID: goal.id, reflection: newReflection)
                                newReflection = ""
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        }

                        Spacer(minLength: 40)

                        HStack {
                            Button("Extend Deadline +2d") {
                                userData.extendDeadline(for: goal.id, byDays: 2)
                            }
                            .buttonStyle(.bordered)

                            Spacer()

                            Button(role: .destructive) {
                                showConfirmComplete = true
                            } label: {
                                Text("Mark Complete")
                            }
                        }
                    }
                    .padding()
                }
                .confirmationDialog("Are you sure?", isPresented: $showConfirmComplete, actions: {
                    Button("Yes, complete") {
                        userData.markGoalCompleted(goal.id)
                    }
                    Button("Cancel", role: .cancel) {}
                })
                .navigationTitle(goal.title)
            } else {
                Text("Goal not found")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
    }
}
