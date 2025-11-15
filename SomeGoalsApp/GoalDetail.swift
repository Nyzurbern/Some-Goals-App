//
//  GoalDetail.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct GoalDetailView: View {
    @EnvironmentObject var userData: UserData
    @Binding var goal: Goal
    
    @State private var newSubTitle: String = ""
    @State private var newReflection: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                // title + coins
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("Title", text: $goal.title)
                            .font(.title2.bold())
                        TextField("Short description", text: $goal.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack {
                        Text("Coins")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(userData.coins)")
                            .font(.title3)
                            .bold()
                            .foregroundStyle(.yellow)
                    }
                }
                
                // deadline
                VStack(alignment: .leading, spacing: 6) {
                    Text("Deadline")
                        .font(.headline)
                    DatePicker("Deadline", selection: $goal.deadline, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                
                // progress 
                VStack(alignment: .leading) {
                    Text("Progress")
                        .font(.headline)
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 18)
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
                            .frame(width: max(10, CGFloat(goal.progress) * (UIScreen.main.bounds.width - 48)), height: 18)
                            .animation(.spring(), value: goal.progress)
                    }
                    Text("\(Int(goal.progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // subgoals
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("Sub-goals")
                            .font(.headline)
                        Spacer()
                    }
                    
                    ForEach(goal.subgoals.indices, id: \.self) { i in
                        HStack {
                            Button {
                                // toggle completion
                                goal.subgoals[i].isCompleted.toggle()
                                if goal.subgoals[i].isCompleted {
                                    userData.coins += goal.subgoals[i].coinReward
                                } else {
                                    // if unchecking, optionally deduct coins or leave as-is
                                }
                            } label: {
                                Image(systemName: goal.subgoals[i].isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(goal.subgoals[i].isCompleted ? .green : .primary)
                            }
                            
                            TextField("Sub-goal", text: $goal.subgoals[i].title)
                            
                            Spacer()
                            
                            Button {
                                // remove subgoal
                                goal.subgoals.remove(at: i)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(8)
                        .background(Color.gray.opacity(0.06))
                        .cornerRadius(10)
                    }
                    
                    // add subgoal field
                    HStack {
                        TextField("New sub-goal", text: $newSubTitle)
                            .textFieldStyle(.roundedBorder)
                        Button {
                            guard !newSubTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            let s = Subgoal(title: newSubTitle)
                            goal.subgoals.append(s)
                            newSubTitle = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                        .disabled(newSubTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                
                // reflections
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reflections")
                        .font(.headline)
                    ForEach(goal.reflections, id: \.self) { ref in
                        Text("• \(ref)")
                            .padding(8)
                            .background(Color.gray.opacity(0.07))
                            .cornerRadius(8)
                    }
                    
                    TextEditor(text: $newReflection)
                        .frame(height: 110)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    
                    Button("Add Reflection") {
                        let trimmed = newReflection.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        goal.reflections.append(trimmed)
                        newReflection = ""
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                }
                
                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Goal")
    }
}

#Preview {
    GoalDetailView(goal: .constant(Goal(title: "Test", description: "Desc", deadline: Date(), subgoals: [Subgoal(title: "A"), Subgoal(title: "B")])))
        .environmentObject(UserData(sample: true))
}
