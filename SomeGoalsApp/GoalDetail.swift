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
    var onComplete: (() -> Void)? // optional callback when goal is marked complete

    @State private var newReflection: String = ""
    @State private var showExtendConfirm: Bool = false
    @State private var showAddSubgoalSheet = false

    private var goalIndex: Int? { userData.goals.firstIndex(where: { $0.id == goalID }) }
    private var goal: Goal? { guard let i = goalIndex else { return nil }; return userData.goals[i] }

    var body: some View {
        VStack {
            if let g = goal {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(g.title).font(.title2).bold()
                        Text(g.description).foregroundColor(.secondary)

                        HStack {
                            Text("Deadline:")
                            Spacer()
                            Text(g.deadline, style: .date).foregroundColor(g.isOverdue ? .red : .primary)
                        }

                        ProgressView(value: g.progressFraction).frame(height: 12)
                        Text(g.percentString).font(.caption).foregroundColor(.secondary)

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Sub-goals").font(.headline)
                            ForEach(g.subgoals) { s in
                                HStack {
                                    Button {
                                        userData.toggleSubgoalCompletion(goalID: g.id, subgoalID: s.id)
                                    } label: {
                                        Image(systemName: s.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(s.isCompleted ? .green : .primary)
                                    }
                                    TextField("Subgoal", text: Binding(
                                        get: { s.title },
                                        set: { newVal in userData.updateSubgoalTitle(goalID: g.id, subgoalID: s.id, newTitle: newVal) }
                                    ))
                                    Spacer()
                                    Button { userData.removeSubgoal(goalID: g.id, subgoalID: s.id) } label: {
                                        Image(systemName: "trash").foregroundColor(.red)
                                    }
                                }
                                .padding(8)
                                .background(Color.gray.opacity(0.06))
                                .cornerRadius(8)
                            }

                            Button("Add Subgoal") { showAddSubgoalSheet = true }
                                .buttonStyle(.borderedProminent)
                                .sheet(isPresented: $showAddSubgoalSheet) {
                                    AddSubGoalPopupView(goalID: g.id) { newSub in userData.addSubgoal(to: g.id, subgoal: newSub) }
                                }
                        }

                        VStack(alignment: .leading) {
                            Text("Reflections").font(.headline)
                            ForEach(g.reflections, id: \.self) { r in
                                Text("• \(r)").padding(8).background(Color.gray.opacity(0.07)).cornerRadius(8)
                            }
                            TextEditor(text: $newReflection).frame(height: 120).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                            Button("Add Reflection") {
                                let trimmed = newReflection.trimmingCharacters(in: .whitespacesAndNewlines)
                                guard !trimmed.isEmpty else { return }
                                userData.addReflection(goalID: g.id, reflection: trimmed)
                                newReflection = ""
                            }.buttonStyle(.borderedProminent)
                        }

                        HStack {
                            Button("Extend +2d") { userData.extendDeadline(for: g.id, byDays: 2) }.buttonStyle(.bordered)
                            Spacer()
                            Button(role: .destructive) { showExtendConfirm = true } label: { Text("Mark Complete") }
                        }
                    }.padding()
                }
                .confirmationDialog("Confirm complete?", isPresented: $showExtendConfirm) {
                    Button("Yes, complete") {
                        let beforeDeadline = Date() <= g.deadline
                        userData.markGoalCompleted(g.id, beforeDeadlineBonus: beforeDeadline)
                        onComplete?()
                    }
                    Button("Cancel", role: .cancel) {}
                }
            } else {
                Text("Goal not found").foregroundColor(.secondary)
            }
        }
    }
}
