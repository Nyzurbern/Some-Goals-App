//
//  Goal.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation

struct Subgoal: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var coinReward: Int = 10
}

struct Goal: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var deadline: Date
    var subgoals: [Subgoal] = []
    var isCompleted: Bool = false
    var reflections: [String] = []
    var character: Character
    

    var progress: Double {
        guard !subgoals.isEmpty else { return 0.0 }
        let done = subgoals.filter { $0.isCompleted }.count
        return Double(done) / Double(subgoals.count)
    }
}

struct Character: Identifiable, Hashable, Codable {
    var id = UUID()
    var image: String
    var waterLevel: Int
    var foodLevel: Int
}
