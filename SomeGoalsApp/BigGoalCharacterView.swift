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
    @Binding var goal: Goal
    var body: some View {
        ScrollView{
            VStack{
                Text("Due Date: ")
                    .bold()
                    .font(.title)
                Image("subject nobody")
                HStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                    .stroke(Color.orange, lineWidth: 3)
                            )
                        HStack{
                            Rectangle()
                                .frame(width: foodRectWidth, height: 40)
                                .frame(maxWidth: 300, alignment: .leading)
                                .foregroundStyle(.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("🍞")
                    }
                    Button{
                        print("Food is served")
                        if foodRectWidth < 300 {
                            foodRectWidth += 10
                        }
                    } label: {
                        Text("Feed")
                            .padding()
                            .background(.orange)
                            .foregroundStyle(.white)
                            .frame(height: 41.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                HStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                        HStack{
                            Rectangle()
                                .frame(width: waterRectWidth, height: 40)
                                .frame(maxWidth: 300, alignment: .leading)
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("💧")
                    }
                    Button{
                        print("Drinks are served")
                        print(waterRectWidth)
                        if waterRectWidth < 300 {
                            waterRectWidth += 10
                        }
                    } label: {
                        Text("Drink")
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .frame(height: 41.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    NavigationStack {
                        HStack {
                            NavigationLink {
                                AddSubGoalPopupView()
                            } label: {
                                Text("Create a subgoal!")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Sub-goals")
                        .font(.headline)
                    Spacer()
                }
                
                ForEach($goal.subgoals, id: \.self) { $subgoal in
                    HStack {
                        Button {
                            // toggle completion
                            $subgoal.isCompleted.wrappedValue.toggle()
                            if subgoal.isCompleted {
                                goal.coins +=
                                subgoal.coinReward
                            } else {
                                // if unchecking, optionally deduct coins or leave as-is
                            }
                        } label: {
                            Image(
                                systemName: subgoal.isCompleted
                                ? "checkmark.circle.fill" : "circle"
                            )
                            .foregroundColor(
                                subgoal.isCompleted
                                ? .green : .primary
                            )
                        }
                        
                        TextField("Sub-goal", text: $subgoal.title)
                        
                        Spacer()
                        
                        Button {
                            // remove subgoal
                            goal.subgoals.removeAll { $0.id == subgoal.id }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Color.gray.opacity(0.06))
        .cornerRadius(10)
    }
    //    private func subgoalRow(index i: Int) -> some View {
    //        HStack {
    //            Button {
    //                goal.subgoals[i].isCompleted.toggle()
    //                if goal.subgoals[i].isCompleted {
    //                    userData.goals = userData.goals.map { g in
    //                        if g.id == goal.id {
    //                            var updated = g
    //                            updated.coins += goal.subgoals[i].coinReward
    //                            return updated
    //                        }
    //                        return g
    //                    }
    //                    // Also update local binding to reflect coins change immediately
    //                    goal.coins += goal.subgoals[i].coinReward
    //                } else {
    //                    // No coin deduction on uncheck (as per comment)
    //                }
    //            } label: {
    //                Image(systemName: goal.subgoals[i].isCompleted ? "checkmark.circle.fill" : "circle")
    //                    .foregroundColor(goal.subgoals[i].isCompleted ? .green : .primary)
    //            }
    //
    //            TextField("Sub-goal", text: $goal.subgoals[i].title)
    //
    //            Spacer()
    //
    //            Button {
    //                goal.subgoals.remove(at: i)
    //            } label: {
    //                Image(systemName: "trash")
    //                    .foregroundColor(.red)
    //            }
    //        }
}

#Preview {
    BigGoalCharacterView(
        goal: .constant(
            Goal(
                title: "Test",
                description: "Desc",
                deadline: Date(),
                subgoals: [Subgoal(title: "A"), Subgoal(title: "B")],
                isCompleted: false,
                reflections: [],
                character: Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30),
                coins: 10
            )
        )
    )
}
