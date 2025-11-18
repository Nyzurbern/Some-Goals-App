//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct BigGoalCharacterView: View {
    @EnvironmentObject var userData: UserData
    @State private var foodRectWidth: CGFloat = 30
    @State private var waterRectWidth: CGFloat = 30
    @ObservedObject var ViewModel: GoalViewModel
    @Binding var goal: Goal
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Character Section
                VStack {
                    Text(goal.deadline, format: .dateTime.day().month().year())
                        .bold()
                        .font(.title)
                    Image(goal.character.image)
                    
                    // Food Bar
                    HStack {
                        ZStack {
                            Rectangle() //this rectangle is the progress bar outside
                                .frame(width: 250, height: 40)
                                .foregroundStyle(.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                        .stroke(Color.orange, lineWidth: 3)
                                )
                            HStack {
                                Rectangle() //this rectangle is the progress bar inside
                                    .frame(width: foodRectWidth, height: 40)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .foregroundStyle(.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Text("🍞")
                        }
                        
                        NavigationLink {
                            FoodShopView(goal: $goal)
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text("Feed")
                                    .padding()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .glassEffect()
                            } else {
                                Text("Feed")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    
                    // Water Bar
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 250, height: 40)
                                .foregroundStyle(.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                        .stroke(Color.blue, lineWidth: 3)
                                )
                            HStack {
                                Rectangle()
                                    .frame(width: waterRectWidth, height: 40)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .foregroundStyle(.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Text("💧")
                        }
                        
                        NavigationLink {
                            DrinksShopView(goal: $goal)
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text("Drink")
                                    .padding()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .glassEffect()
                            } else {
                                Text("Drink")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.06))
                .cornerRadius(12)
            
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Sub-goals")
                            .font(.title2.bold())
                        Spacer()
                        
                        NavigationLink {
                            AddSubGoalPopupView(goal: $goal)
                        } label: {
                            Text("Add Subgoal")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    if goal.subgoals.isEmpty {
                        Text("No subgoals yet. Add one to get started!")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        List {
                            ForEach($goal.subgoals) { $subgoal in
                                HStack {
                                    Button {
                                        $subgoal.isCompleted.wrappedValue.toggle()
                                        if subgoal.isCompleted {
                                            goal.coins += subgoal.coinReward
                                        } else {
                                            goal.coins -= subgoal.coinReward
                                        }
                                    } label: {
                                        Image(systemName: subgoal.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(subgoal.isCompleted ? .green : .primary)
                                            .font(.title2)
                                    }
                                    
                                    TextField("Sub-goal", text: $subgoal.title)
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Text("+\(subgoal.coinReward) coins")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.yellow.opacity(0.2))
                                        .cornerRadius(4)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                goal.subgoals.remove(atOffsets: indexSet)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden) //
                        .background(Color.clear)
                        .frame(height: CGFloat(goal.subgoals.count) * 70 + 20) //had to do this for like 200 times bruh
                        //or else the code straight up just doesnt work becuz apparently lists cant be inside scrollviews
                        //stupid swiftui
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }
}
