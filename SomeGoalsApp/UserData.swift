//
//  UserData.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation
import Combine
import CoreGraphics

final class UserData: ObservableObject {
    @Published var goals: [Goal] = []
    
    init(sample: Bool = false) {
        if sample {
            goals = [
                Goal(
                    title: "Write Essay",
                    description: "Finish the 1500-word essay on climate.",
                    deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                    subgoals: [
                        Subgoal(title: "Outline", coinReward: 10),
                        Subgoal(title: "Draft", coinReward: 20),
                        Subgoal(title: "Proofread", coinReward: 10)
                    ],
                    reflections: ["Start early next time"],
                    character: Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30),
                    coins: 10,
                    foodprogressbar: CGFloat(30),
                    drinksprogressbar: CGFloat(30)
                )
            ]
        }
    }
}
