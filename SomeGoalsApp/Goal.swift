//
//  Goal.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation

enum GoalStatus: String, Codable {
    case pending, inProgress, completed, expired, archived
}

struct Subgoal: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var coinReward: Int
    var completedAt: Date?

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false, coinReward: Int = 10, completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.coinReward = coinReward
        self.completedAt = completedAt
    }
}

struct CharacterModel: Identifiable, Hashable, Codable {
    let id: UUID
    var profileImage: String
    var image: String
    var waterLevel: Int
    var foodLevel: Int

    init(id: UUID = UUID(), profileImage: String, image: String, waterLevel: Int = 50, foodLevel: Int = 50) {
        self.id = id
        self.profileImage = profileImage
        self.image = image
        self.waterLevel = waterLevel
        self.foodLevel = foodLevel
    }
}

struct Goal: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var description: String
    var deadline: Date
    var subgoals: [Subgoal]
    var isCompleted: Bool
    var reflections: [String]
    var character: CharacterModel
    var status: GoalStatus
    var completedAt: Date?

    init(id: UUID = UUID(),
         title: String,
         description: String,
         deadline: Date,
         subgoals: [Subgoal] = [],
         isCompleted: Bool = false,
         reflections: [String] = [],
         character: CharacterModel,
         status: GoalStatus = .pending,
         completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.subgoals = subgoals
        self.isCompleted = isCompleted
        self.reflections = reflections
        self.character = character
        self.status = status
        self.completedAt = completedAt
    }

    var progressFraction: Double {
        guard !subgoals.isEmpty else {
            // If no subgoals, use binary completion flag for goals with no subtasks
            return isCompleted ? 1.0 : 0.0
        }
        let done = subgoals.filter { $0.isCompleted }.count
        return Double(done) / Double(subgoals.count)
    }

    var percentString: String {
        "\(Int(progressFraction * 100))%"
    }

    var isOverdue: Bool {
        Date() > deadline && status != .completed && status != .archived
    }
}
