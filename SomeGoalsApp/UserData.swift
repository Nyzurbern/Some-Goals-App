//
//  UserData.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation
import Combine

final class UserData: ObservableObject {
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var coins: Int = 0
    @Published private(set) var xp: Int = 0

    private let saveKey = "user-data-v1"
    private var cancellables = Set<AnyCancellable>()

    // Keep track of which subgoal or goal rewards have already been claimed
    // to prevent toggling or re-awarding coins.
    private var claimedSubgoalRewards: Set<UUID> = []
    private var claimedGoalRewards: Set<UUID> = []

    init(sample: Bool = false) {
        if sample {
            seedSample()
        } else {
            load()
        }
        // check deadlines on init
        checkDeadlinesAndExpire()
        
        $goals.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $coins.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $xp.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
    }


    private func save() {
        let wrapper = StorageWrapper(goals: goals, coins: coins, xp: xp, claimedSubgoalRewards: Array(claimedSubgoalRewards), claimedGoalRewards: Array(claimedGoalRewards))
        do {
            let data = try JSONEncoder().encode(wrapper)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Save error:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        do {
            let wrapper = try JSONDecoder().decode(StorageWrapper.self, from: data)
            self.goals = wrapper.goals
            self.coins = wrapper.coins
            self.xp = wrapper.xp
            self.claimedSubgoalRewards = Set(wrapper.claimedSubgoalRewards)
            self.claimedGoalRewards = Set(wrapper.claimedGoalRewards)
        } catch {
            print("Load error:", error)
        }
    }

    private struct StorageWrapper: Codable {
        var goals: [Goal]
        var coins: Int
        var xp: Int
        var claimedSubgoalRewards: [UUID]
        var claimedGoalRewards: [UUID]
    }


    private func seedSample() {
        let char = CharacterModel(profileImage: "Subject 3", image: "subject nobody")
        self.goals = [
            Goal(title: "Finish mini project",
                 description: "Complete basic features and tests",
                 deadline: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
                 subgoals: [
                    Subgoal(title: "Backend API", coinReward: 30),
                    Subgoal(title: "Frontend UI", coinReward: 20),
                    Subgoal(title: "Write tests", coinReward: 10)
                 ],
                 character: char),
            Goal(title: "Drink more water",
                 description: "Daily hydration habit",
                 deadline: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
                 subgoals: [],
                 character: char)
        ]
        self.coins = 50
        self.xp = 0
    }


    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }

    func updateGoal(_ goal: Goal) {
        guard let i = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[i] = goal
    }

    func removeGoal(id: UUID) {
        goals.removeAll { $0.id == id }
    }

    func extendDeadline(for goalID: UUID, byDays days: Int) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[i].deadline = Calendar.current.date(byAdding: .day, value: days, to: goals[i].deadline) ?? goals[i].deadline
        if goals[i].status == .expired && !goals[i].isOverdue {
            goals[i].status = .inProgress
        }
    }

    func markGoalCompleted(_ goalID: UUID) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        guard goals[i].status != .completed else { return }
        goals[i].status = .completed
        goals[i].isCompleted = true
        goals[i].completedAt = Date()
        // award coins if any remaining (only once)
        if !claimedGoalRewards.contains(goalID) {
            let remainingReward = calculateGoalReward(goal: goals[i])
            coins += remainingReward
            xp += Int(remainingReward / 2)
            claimedGoalRewards.insert(goalID)
        }
    }

    func markGoalExpired(_ goalID: UUID) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[i].status = .expired
    }

    func updateSubgoalTitle(goalID: UUID, subgoalID: UUID, newTitle: String) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }),
              let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }
        goals[gIndex].subgoals[sIndex].title = newTitle
    }

    func removeSubgoal(goalID: UUID, subgoalID: UUID) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }),
              let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }
        // If reward already claimed for this subgoal, keep claimed set as-is so user can't relaim by re-adding same ID
        goals[gIndex].subgoals.remove(at: sIndex)
        // if removing caused the goal to have zero subgoals and it's completed flag, we leave it as-is; UI logic can handle
        if goals[gIndex].subgoals.isEmpty && goals[gIndex].isCompleted {
            // nothing special
        }
        // Recompute status
        if goals[gIndex].progressFraction >= 1.0 {
            markGoalCompleted(goals[gIndex].id)
        } else if goals[gIndex].status == .pending {
            goals[gIndex].status = .inProgress
        }
    }

    // Toggle subgoal completion with reward guard (already present)
    func toggleSubgoalCompletion(goalID: UUID, subgoalID: UUID) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }) else { return }
        guard let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }

        // toggle safely
        let wasCompleted = goals[gIndex].subgoals[sIndex].isCompleted
        goals[gIndex].subgoals[sIndex].isCompleted.toggle()
        goals[gIndex].subgoals[sIndex].completedAt = goals[gIndex].subgoals[sIndex].isCompleted ? Date() : nil

        // award on completion only, and prevent double-claim exploits
        if goals[gIndex].subgoals[sIndex].isCompleted && !claimedSubgoalRewards.contains(subgoalID) {
            let reward = goals[gIndex].subgoals[sIndex].coinReward
            coins += reward
            xp += max(1, reward / 5)
            claimedSubgoalRewards.insert(subgoalID)
        } else if !goals[gIndex].subgoals[sIndex].isCompleted && wasCompleted {
            // user unchecked a subgoal so likedo not deduct coins, but DO NOT allow re-laiming by toggling repeatedly
            // keep the claimedSubgoalRewards set intact to prevent farming
        }

        // update goal status
        if goals[gIndex].progressFraction >= 1.0 {
            markGoalCompleted(goals[gIndex].id)
        } else if goals[gIndex].status == .pending {
            goals[gIndex].status = .inProgress
        }
    }

    func addSubgoal(to goalID: UUID, subgoal: Subgoal) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[i].subgoals.append(subgoal)
        if goals[i].status == .pending { goals[i].status = .inProgress }
    }

    func addReflection(goalID: UUID, reflection: String) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        let trimmed = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        goals[i].reflections.append(trimmed)
    }

    func checkDeadlinesAndExpire() {
        let now = Date()
        for idx in goals.indices {
            if goals[idx].status != .completed && goals[idx].deadline < now && goals[idx].status != .expired {
                goals[idx].status = .expired
            }
        }
    }


    func spendCoins(_ amount: Int) -> Bool {
        guard amount >= 0 else { return false }
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }

    func addCoins(_ amount: Int) {
        guard amount > 0 else { return }
        coins += amount
    }

    // simple reward calculation for completing the whole goal (beyond subgoal rewards).
    private func calculateGoalReward(goal: Goal) -> Int {
        // if a goal had no subgoals, give a base reward; otherwise small bonus
        let base = max(30, Int(goal.subgoals.count) * 10)
        return base
    }
}
