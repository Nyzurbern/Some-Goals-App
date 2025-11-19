//
//  AddReflectionView.swift
//  SomeGoalsApp
//
//  Created by Administrator on 19/11/25.
//

import SwiftUI

struct AddReflectionView: View {
    @Binding var goal: Goal
    @Environment(\.dismiss) private var dismiss // Optional: to dismiss the view after archiving
    
    var body: some View {
        Form {
            Section(header: Text("Goal Details")) {
                Text("What challenges or obstacles did I experience? How did I overcome them, or what prevented me from doing so?")
                TextField(
                    "Type here...",
                    text: $goal.challenges
                )
                .textInputAutocapitalization(.sentences)
                Text("What specific actions or habits contributed most to my progress?")
                TextField(
                    "Type here...",
                    text: $goal.actionsorhabits
                )
                .textInputAutocapitalization(.sentences)
                Text("What resources or support were most helpful?")
                TextField(
                    "Type here...",
                    text: $goal.resourcesorsupport
                )
                .textInputAutocapitalization(.sentences)
            }
            
            // Archive button section
            Section {
                            Button(action: archiveGoal) {
                                HStack {
                                    Spacer()
                                    Text("Archive Goal")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }
                            }
                            .foregroundColor(.red)
                        }
                    }
                    .navigationTitle("Add Reflection")
                }
                
                private func archiveGoal() {
                    print("Archive button tapped for goal: \(goal.title)")
                    
                    goal.isCompleted = true
                    
                    if let index = userData.goals.firstIndex(where: { $0.id == goal.id }) {
                        userData.goals[index] = goal
                    }
                    
                    shouldDismissToRoot = true
                    dismiss()
                }
