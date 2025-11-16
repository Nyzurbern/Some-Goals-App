//
//  UserData.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

// UserData.swift
// Core state, persistence, and shop logic (no creatures / no themes)

import Foundation
import Combine
import SwiftUI

final public class UserData: ObservableObject {
    // Core state
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var coins: Int = 0
    @Published private(set) var xp: Int = 0
    @Published private(set) var buildings: [Building] = []
    @Published private(set) var dailyMissions: [DailyMission] = []
    @Published private(set) var morale: Int = 0
    @Published private(set) var streakDays: Int = 0
    @Published private(set) var ownedShopItemIDs: Set<UUID> = []
    @Published private(set) var shopItems: [ShopItem] = []

    // global persistent modifiers
    @Published private(set) var globalProductionMultiplier: Double = 1.0

    // Persistence
    private let saveKey = "island-progress-v2"
    private var cancellables = Set<AnyCancellable>()

    // Claim guards / bookkeeping
    private var claimedSubgoalRewards: Set<UUID> = []
    private var claimedGoalRewards: Set<UUID> = []
    private var lastActiveDate: Date?

    public init(sample: Bool = false) {
        if sample { seedSample() } else { load() }
        checkDeadlinesAndExpire()
        startDailyResetObserver()

        // persist important published properties
        $goals.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $coins.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $xp.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $buildings.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $dailyMissions.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $morale.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $streakDays.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $ownedShopItemIDs.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $shopItems.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
        $globalProductionMultiplier.sink { [weak self] _ in self?.save() }.store(in: &cancellables)
    }

    private struct StorageWrapper: Codable {
        var goals: [Goal]
        var coins: Int
        var xp: Int
        var buildings: [Building]
        var dailyMissions: [DailyMission]
        var morale: Int
        var streakDays: Int
        var ownedShopItemIDs: [UUID]
        var shopItems: [ShopItem]
        var claimedSubgoalRewards: [UUID]
        var claimedGoalRewards: [UUID]
        var lastActiveDate: Date?
        var globalProductionMultiplier: Double
    }

    private func save() {
        let wrapper = StorageWrapper(
            goals: goals,
            coins: coins,
            xp: xp,
            buildings: buildings,
            dailyMissions: dailyMissions,
            morale: morale,
            streakDays: streakDays,
            ownedShopItemIDs: Array(ownedShopItemIDs),
            shopItems: shopItems,
            claimedSubgoalRewards: Array(claimedSubgoalRewards),
            claimedGoalRewards: Array(claimedGoalRewards),
            lastActiveDate: lastActiveDate,
            globalProductionMultiplier: globalProductionMultiplier
        )
        do {
            let data = try JSONEncoder().encode(wrapper)
            UserDefaults.standard.set(data, forKey: saveKey)
        } catch {
            print("Save error:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { seedSample(); return }
        do {
            let wrapper = try JSONDecoder().decode(StorageWrapper.self, from: data)
            self.goals = wrapper.goals
            self.coins = wrapper.coins
            self.xp = wrapper.xp
            self.buildings = wrapper.buildings
            self.dailyMissions = wrapper.dailyMissions
            self.morale = wrapper.morale
            self.streakDays = wrapper.streakDays
            self.ownedShopItemIDs = Set(wrapper.ownedShopItemIDs)
            self.shopItems = wrapper.shopItems
            self.claimedSubgoalRewards = Set(wrapper.claimedSubgoalRewards)
            self.claimedGoalRewards = Set(wrapper.claimedGoalRewards)
            self.lastActiveDate = wrapper.lastActiveDate
            self.globalProductionMultiplier = wrapper.globalProductionMultiplier
        } catch {
            print("Load error:", error)
            seedSample()
        }
    }

    // MARK: - Sample / seeding (includes many shop items)
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
                 deadline: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
                 subgoals: [],
                 character: char)
        ]

        self.coins = 50
        self.xp = 0
        self.buildings = [
            Building(type: .townHall),
            Building(type: .coinMine)
        ]

        self.dailyMissions = [
            DailyMission(title: "Complete 1 subgoal", rewardCoins: 15, rewardXP: 5, isCompletedToday: false, requires: .completeSubgoalCount(1)),
            DailyMission(title: "Add a reflection", rewardCoins: 10, rewardXP: 3, isCompletedToday: false, requires: .reflectionCount(1))
        ]

        self.morale = 10
        self.streakDays = 0
        self.lastActiveDate = Date()

        // --- Powerful, meaningful shop items (buildings + boosters) ---
        self.shopItems = [
            // Building blueprints (one-time)
            ShopItem(title: "Coin Mine Blueprint", description: "Adds another coin mine (produces coins automatically).", price: 120, category: .buildings, buildingType: .coinMine, assetName: "mine_lvl1", oneTimePurchase: true),
            ShopItem(title: "Town Hall Blueprint", description: "Add a Town Hall (improves base abilities).", price: 650, category: .buildings, buildingType: .townHall, assetName: "townhall_lvl1", oneTimePurchase: true),
            ShopItem(title: "Farm Blueprint", description: "Adds a farm — steady production and morale synergy.", price: 280, category: .buildings, buildingType: .farm, assetName: "farm_lvl1", oneTimePurchase: true),

            // Boosters / Consumables
            ShopItem(title: "Small Coin Pack", description: "Instant +200 coins.", price: 80, category: .boosters, instantCoins: 200, oneTimePurchase: false),
            ShopItem(title: "Large Coin Pack", description: "Instant +600 coins.", price: 200, category: .boosters, instantCoins: 600, oneTimePurchase: false),
            ShopItem(title: "XP Booster", description: "Instant +150 XP.", price: 140, category: .boosters, instantXP: 150, oneTimePurchase: false),
            ShopItem(title: "Morale Pack", description: "Instant +20 morale.", price: 90, category: .boosters, instantMorale: 20, oneTimePurchase: false),

            // Production multipliers (persistent global effect)
            ShopItem(title: "Production Booster I", description: "Increase all building production by 10% (persistent).", price: 300, category: .boosters, globalProductionMultiplier: 1.10, oneTimePurchase: true),
            ShopItem(title: "Production Booster II", description: "Increase all building production by 30% (persistent).", price: 800, category: .boosters, globalProductionMultiplier: 1.30, oneTimePurchase: true),

            // Building upgrade vouchers (instantly level up a building of the target type)
            ShopItem(title: "Instant Upgrade: Coin Mine +1", description: "Instantly upgrade one Coin Mine by 1 level.", price: 220, category: .boosters, upgradeTargetType: .coinMine, upgradeLevels: 1, oneTimePurchase: true),
            ShopItem(title: "Instant Upgrade: Any Building +2", description: "Instantly upgrade any building of chosen type by 2 levels (first matching chosen type found).", price: 600, category: .boosters, upgradeLevels: 2, oneTimePurchase: true)
        ]

        self.ownedShopItemIDs = []
        self.globalProductionMultiplier = 1.0
    }

    // Shop logic (codable-friendly)
    // Purchase returns true if purchase succeeded and effects applied
    public func buyShopItem(_ item: ShopItem) -> Bool {
        guard coins >= item.price else { return false }

        // Deduct cost first
        coins -= item.price

        // Instant effects
        if let c = item.instantCoins { coins += c }
        if let xpAdd = item.instantXP { xp += xpAdd }
        if let m = item.instantMorale { morale = min(100, morale + m) }

        // Global production multiplier (apply multiplicatively; persistent)
        if let mult = item.globalProductionMultiplier {
            // multiply the globalProductionMultiplier by the given multiplier
            globalProductionMultiplier *= mult
            // Persisting globally will alter future production calculations
        }

        // Place building blueprint if provided
        if let btype = item.buildingType {
            // place building with zero cost (blueprint grants building)
            let _ = placeBuilding(ofType: btype, cost: 0, customName: nil)
        }

        // Upgrade behavior: try to find a building of `upgradeTargetType` if specified; otherwise pick first non-max building
        if let levels = item.upgradeLevels {
            if let targetType = item.upgradeTargetType {
                if let idx = buildings.firstIndex(where: { $0.type == targetType && !$0.isMaxLevel }) {
                    buildings[idx].level = min(buildings[idx].type.maxLevel, buildings[idx].level + levels)
                }
            } else {
                // any building
                if let idx = buildings.firstIndex(where: { !$0.isMaxLevel }) {
                    buildings[idx].level = min(buildings[idx].type.maxLevel, buildings[idx].level + levels)
                }
            }
        }

        // One-time purchases are marked as owned and removed from the shop list (optional UX)
        if item.oneTimePurchase {
            ownedShopItemIDs.insert(item.id)
            // remove item from the visible shop list (so player can't buy again)
            shopItems.removeAll { $0.id == item.id }
        }

        // small XP reward for buying impactful things
        xp += max(0, item.price / 30)

        return true
    }

    public func addShopItem(_ item: ShopItem) {
        shopItems.append(item)
    }

    // MARK: - Daily reset & missions
    private func startDailyResetObserver() {
        DispatchQueue.main.async { [weak self] in self?.dailyResetIfNeeded() }
    }

    private func dailyResetIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        if let last = lastActiveDate {
            if !calendar.isDate(last, inSameDayAs: now) {
                let hadCompletionYesterday = dailyMissions.contains(where: { $0.isCompletedToday })
                if hadCompletionYesterday {
                    streakDays += 1
                    morale = min(100, morale + 3)
                } else {
                    streakDays = 0
                    morale = max(0, morale - 2)
                }
                for i in dailyMissions.indices { dailyMissions[i].isCompletedToday = false }
            }
        } else {
            for i in dailyMissions.indices { dailyMissions[i].isCompletedToday = false }
        }
        lastActiveDate = now
    }

    public func appDidBecomeActive() {
        dailyResetIfNeeded()
        checkDeadlinesAndExpire()
        finishPendingUpgrades()
    }

    // MARK: - Goals API (unchanged)
    public func addGoal(_ goal: Goal) { goals.append(goal) }
    public func updateGoal(_ goal: Goal) {
        guard let i = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        goals[i] = goal
    }
    public func removeGoal(id: UUID) { goals.removeAll { $0.id == id } }

    public func extendDeadline(for goalID: UUID, byDays days: Int) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[i].deadline = Calendar.current.date(byAdding: .day, value: days, to: goals[i].deadline) ?? goals[i].deadline
        if goals[i].status == .expired && !goals[i].isOverdue { goals[i].status = .inProgress }
    }

    public func markGoalCompleted(_ goalID: UUID, beforeDeadlineBonus: Bool = false) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        guard goals[i].status != .completed else { return }
        goals[i].status = .completed
        goals[i].isCompleted = true
        goals[i].completedAt = Date()
        if !claimedGoalRewards.contains(goalID) {
            let remainingReward = calculateGoalReward(goal: goals[i])
            let bonusMultiplier = beforeDeadlineBonus ? 1.5 : 1.0
            let finalCoins = Int(Double(remainingReward) * bonusMultiplier)
            coins += finalCoins
            xp += Int(finalCoins / 2)
            claimedGoalRewards.insert(goalID)
            morale = min(100, morale + 5)
        }
    }

    public func toggleSubgoalCompletion(goalID: UUID, subgoalID: UUID) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }) else { return }
        guard let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }

        goals[gIndex].subgoals[sIndex].isCompleted.toggle()
        goals[gIndex].subgoals[sIndex].completedAt = goals[gIndex].subgoals[sIndex].isCompleted ? Date() : nil

        if goals[gIndex].subgoals[sIndex].isCompleted && !claimedSubgoalRewards.contains(subgoalID) {
            let reward = Int(Double(goals[gIndex].subgoals[sIndex].coinReward) * moraleMultiplier())
            coins += reward
            xp += max(1, reward / 5)
            claimedSubgoalRewards.insert(subgoalID)
            markMissionsForSubgoalCompletion()
        }

        if goals[gIndex].progressFraction >= 1.0 {
            let beforeDeadline = Date() <= goals[gIndex].deadline
            markGoalCompleted(goals[gIndex].id, beforeDeadlineBonus: beforeDeadline)
        } else if goals[gIndex].status == .pending {
            goals[gIndex].status = .inProgress
        }
    }

    public func addSubgoal(to goalID: UUID, subgoal: Subgoal) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        goals[i].subgoals.append(subgoal)
        if goals[i].status == .pending { goals[i].status = .inProgress }
    }

    public func updateSubgoalTitle(goalID: UUID, subgoalID: UUID, newTitle: String) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }),
              let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }
        goals[gIndex].subgoals[sIndex].title = newTitle
    }

    public func removeSubgoal(goalID: UUID, subgoalID: UUID) {
        guard let gIndex = goals.firstIndex(where: { $0.id == goalID }),
              let sIndex = goals[gIndex].subgoals.firstIndex(where: { $0.id == subgoalID }) else { return }
        goals[gIndex].subgoals.remove(at: sIndex)
        if goals[gIndex].progressFraction >= 1.0 {
            markGoalCompleted(goals[gIndex].id)
        }
    }

    public func addReflection(goalID: UUID, reflection: String) {
        guard let i = goals.firstIndex(where: { $0.id == goalID }) else { return }
        let trimmed = reflection.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        goals[i].reflections.append(trimmed)
        markMissionsForReflection()
    }

    public func checkDeadlinesAndExpire() {
        let now = Date()
        for idx in goals.indices {
            if goals[idx].status != .completed && goals[idx].deadline < now && goals[idx].status != .expired {
                goals[idx].status = .expired
                morale = max(0, morale - 3)
            }
        }
    }

    // Mission helpers
    private func markMissionsForSubgoalCompletion() {
        for i in dailyMissions.indices {
            switch dailyMissions[i].requires {
            case .completeSubgoalCount:
                if !dailyMissions[i].isCompletedToday {
                    dailyMissions[i].isCompletedToday = true
                    coins += dailyMissions[i].rewardCoins
                    xp += dailyMissions[i].rewardXP
                    morale = min(100, morale + 1)
                }
            default:
                continue
            }
        }
    }

    private func markMissionsForReflection() {
        for i in dailyMissions.indices {
            switch dailyMissions[i].requires {
            case .reflectionCount:
                if !dailyMissions[i].isCompletedToday {
                    dailyMissions[i].isCompletedToday = true
                    coins += dailyMissions[i].rewardCoins
                    xp += dailyMissions[i].rewardXP
                    morale = min(100, morale + 1)
                }
            default:
                continue
            }
        }
    }

    // Buildings
    public func placeBuilding(ofType type: BuildingType, cost: Int, customName: String? = nil) -> Bool {
        guard cost >= 0 else { return false }
        if coins < cost { return false }
        coins -= cost
        let b = Building(type: type, level: 1, placedAt: Date(), lastCollectedAt: Date(), upgradeCompletionAt: nil, customName: customName)
        buildings.append(b)
        morale = min(100, morale + 2)
        return true
    }

    public func collectFromBuilding(_ buildingID: UUID) -> Int {
        guard let i = buildings.firstIndex(where: { $0.id == buildingID }) else { return 0 }
        let amount = buildings[i].uncollectedCoins(since: Date(), globalMultiplier: globalProductionMultiplier)
        if amount > 0 { coins += amount }
        buildings[i].lastCollectedAt = Date()
        return amount
    }

    @discardableResult
    public func collectAllBuildings() -> Int {
        var total = 0
        let now = Date()
        for idx in buildings.indices {
            let amount = buildings[idx].uncollectedCoins(since: now, globalMultiplier: globalProductionMultiplier)
            if amount > 0 {
                total += amount
                buildings[idx].lastCollectedAt = now
            }
        }
        if total > 0 { coins += total }
        return total
    }

    public func startUpgradeBuilding(_ buildingID: UUID) -> Bool {
        guard let i = buildings.firstIndex(where: { $0.id == buildingID }) else { return false }
        if buildings[i].isMaxLevel { return false }
        let cost = buildings[i].upgradeCost()
        if coins < cost { return false }
        coins -= cost
        let duration = buildings[i].upgradeDuration()
        buildings[i].upgradeCompletionAt = Date().addingTimeInterval(duration)
        xp += max(1, cost / 25)
        return true
    }

    public func finishPendingUpgrades() {
        let now = Date()
        for idx in buildings.indices {
            if let doneAt = buildings[idx].upgradeCompletionAt, doneAt <= now {
                buildings[idx].level = min(buildings[idx].type.maxLevel, buildings[idx].level + 1)
                buildings[idx].upgradeCompletionAt = nil
                xp += 5
            }
        }
    }

    public func upgradeBuildingInstant(_ buildingID: UUID) -> Bool {
        guard let i = buildings.firstIndex(where: { $0.id == buildingID }) else { return false }
        if buildings[i].isMaxLevel { return false }
        let cost = buildings[i].upgradeCost()
        if coins < cost { return false }
        coins -= cost
        buildings[i].level += 1
        buildings[i].lastCollectedAt = Date()
        xp += max(1, cost / 20)
        return true
    }

    // Coins / misc
    public func spendCoins(_ amount: Int) -> Bool {
        guard amount >= 0 else { return false }
        if coins >= amount { coins -= amount; return true }
        return false
    }

    public func addCoins(_ amount: Int) {
        guard amount > 0 else { return }
        coins += amount
    }

    private func calculateGoalReward(goal: Goal) -> Int {
        let subSum = goal.subgoals.reduce(0) { $0 + $1.coinReward }
        let base = max(30, subSum / 2)
        return base
    }

    private func moraleMultiplier() -> Double {
        let m = Double(morale)
        return 0.9 + (m / 100.0) * 0.6
    }

    public func islandProductionMultiplier() -> Double { globalProductionMultiplier }

    public func completeMission(_ missionID: UUID) {
        guard let idx = dailyMissions.firstIndex(where: { $0.id == missionID }) else { return }
        guard !dailyMissions[idx].isCompletedToday else { return }
        dailyMissions[idx].isCompletedToday = true
        coins += dailyMissions[idx].rewardCoins
        xp += dailyMissions[idx].rewardXP
        morale = min(100, morale + 2)
    }

    public func completeDailyMission(_ missionID: UUID) {
        completeMission(missionID)
    }

    public func addDailyMission(_ mission: DailyMission) {
        dailyMissions.append(mission)
    }

    public func applicationDidBecomeActive() {
        dailyResetIfNeeded()
        finishPendingUpgrades()
        checkDeadlinesAndExpire()
    }

    // small helper for UI to add owned item
    public func addItemToInventory(_ item: ShopItem) {
        ownedShopItemIDs.insert(item.id)
        if item.oneTimePurchase {
            shopItems.removeAll { $0.id == item.id }
        }
    }
}
