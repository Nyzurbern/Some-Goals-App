//
//  Goal.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//


import Foundation
import SwiftUI



public enum GoalStatus: String, Codable {
    case pending, inProgress, completed, expired, archived
}

public struct Subgoal: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var isCompleted: Bool
    public var coinReward: Int
    public var xpReward: Int
    public var completedAt: Date?

    public init(id: UUID = UUID(), title: String, isCompleted: Bool = false, coinReward: Int = 10, xpReward: Int = 5, completedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.coinReward = coinReward
        self.xpReward = xpReward
        self.completedAt = completedAt
    }
}

public struct CharacterModel: Identifiable, Hashable, Codable {
    public let id: UUID
    public var profileImage: String
    public var image: String

    public init(id: UUID = UUID(), profileImage: String = "Subject 3", image: String = "subject nobody") {
        self.id = id
        self.profileImage = profileImage
        self.image = image
    }
}

public struct Goal: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var deadline: Date
    public var subgoals: [Subgoal]
    public var isCompleted: Bool
    public var reflections: [String]
    public var character: CharacterModel
    public var status: GoalStatus
    public var createdAt: Date
    public var completedAt: Date?

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        deadline: Date,
        subgoals: [Subgoal] = [],
        isCompleted: Bool = false,
        reflections: [String] = [],
        character: CharacterModel = CharacterModel(),
        status: GoalStatus = .pending,
        createdAt: Date = Date(),
        completedAt: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.deadline = deadline
        self.subgoals = subgoals
        self.isCompleted = isCompleted
        self.reflections = reflections
        self.character = character
        self.status = status
        self.createdAt = createdAt
        self.completedAt = completedAt
    }

    public var progressFraction: Double {
        guard !subgoals.isEmpty else { return isCompleted ? 1.0 : 0.0 }
        let done = subgoals.filter { $0.isCompleted }.count
        return Double(done) / Double(subgoals.count)
    }

    public var percentString: String { "\(Int(progressFraction * 100))%" }

    public var isOverdue: Bool { Date() > deadline && status != .completed && status != .archived }

    public mutating func ensureStatusConsistency() {
        if status == .completed { isCompleted = true }
    }
}

// Buildings

public enum BuildingType: String, Codable, CaseIterable {
    case townHall
    case coinMine
    case workshop
    case shrine
    case decoration
    case farm

    public var displayName: String {
        switch self {
        case .townHall: return "Town Hall"
        case .coinMine: return "Coin Mine"
        case .workshop: return "Workshop"
        case .shrine: return "Shrine"
        case .decoration: return "Decoration"
        case .farm: return "Farm"
        }
    }

    public var baseProductionPerHour: Double {
        switch self {
        case .coinMine: return 25
        case .farm: return 8
        default: return 0
        }
    }

    public var baseUpgradeCost: Int {
        switch self {
        case .townHall: return 800
        case .coinMine: return 250
        case .workshop: return 150
        case .shrine: return 120
        case .decoration: return 40
        case .farm: return 180
        }
    }

    public var maxLevel: Int { 10 }

    public var imageName: String {
        switch self {
        case .townHall: return "townhall_lvl1"
        case .coinMine: return "mine_lvl1"
        case .workshop: return "workshop_lvl1"
        case .shrine: return "shrine_lvl1"
        case .decoration: return "decoration_1"
        case .farm: return "farm_lvl1"
        }
    }
}

public struct Building: Identifiable, Hashable, Codable {
    public let id: UUID
    public var type: BuildingType
    public var level: Int
    public var placedAt: Date
    public var lastCollectedAt: Date?
    public var upgradeCompletionAt: Date?
    public var customName: String?

    public init(id: UUID = UUID(), type: BuildingType, level: Int = 1, placedAt: Date = Date(), lastCollectedAt: Date? = nil, upgradeCompletionAt: Date? = nil, customName: String? = nil) {
        self.id = id
        self.type = type
        self.level = level
        self.placedAt = placedAt
        self.lastCollectedAt = lastCollectedAt
        self.upgradeCompletionAt = upgradeCompletionAt
        self.customName = customName
    }

    public func productionPerHour(globalMultiplier: Double = 1.0) -> Double {
        let base = type.baseProductionPerHour
        return base * pow(1.45, Double(level - 1)) * globalMultiplier
    }

    public func uncollectedCoins(since now: Date = Date(), globalMultiplier: Double = 1.0) -> Int {
        guard productionPerHour(globalMultiplier: globalMultiplier) > 0 else { return 0 }
        let sinceDate = lastCollectedAt ?? placedAt
        let interval = now.timeIntervalSince(sinceDate)
        let hours = interval / 3600.0
        let produced = productionPerHour(globalMultiplier: globalMultiplier) * hours
        return Int(floor(produced))
    }

    public func upgradeCost(nextLevel: Int? = nil) -> Int {
        let target = nextLevel ?? (level + 1)
        let base = type.baseUpgradeCost
        let cost = Double(base) * pow(1.8, Double(target - 1))
        return max(10, Int(round(cost)))
    }

    public var isMaxLevel: Bool { level >= type.maxLevel }

    public func upgradeDuration() -> TimeInterval {
        let baseSec = 30.0
        return baseSec * pow(1.5, Double(level - 1))
    }
}

//Shop

public enum ShopCategory: String, Codable, CaseIterable {
    case buildings
    case boosters

    public var displayName: String {
        switch self {
        case .buildings: return "Buildings"
        case .boosters: return "Boosters"
        }
    }
}

public struct ShopItem: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var price: Int
    public var category: ShopCategory

    // optional building blueprint (if set, buying places a building)
    public var buildingType: BuildingType?

    // instant effects (codable simple fields)
    public var instantCoins: Int? // gives coins immediately
    public var instantXP: Int?
    public var instantMorale: Int?

    // persistent/global effect
    public var globalProductionMultiplier: Double? // multiplies all building production (applies once)

    // upgrade: instantly level-up one building of `upgradeTargetType` by `upgradeLevels`
    public var upgradeTargetType: BuildingType?
    public var upgradeLevels: Int?

    public var assetName: String?
    public var oneTimePurchase: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        description: String,
        price: Int,
        category: ShopCategory,
        buildingType: BuildingType? = nil,
        instantCoins: Int? = nil,
        instantXP: Int? = nil,
        instantMorale: Int? = nil,
        globalProductionMultiplier: Double? = nil,
        upgradeTargetType: BuildingType? = nil,
        upgradeLevels: Int? = nil,
        assetName: String? = nil,
        oneTimePurchase: Bool = true
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.category = category
        self.buildingType = buildingType
        self.instantCoins = instantCoins
        self.instantXP = instantXP
        self.instantMorale = instantMorale
        self.globalProductionMultiplier = globalProductionMultiplier
        self.upgradeTargetType = upgradeTargetType
        self.upgradeLevels = upgradeLevels
        self.assetName = assetName
        self.oneTimePurchase = oneTimePurchase
    }

    public func isOwned(by user: UserData) -> Bool {
        oneTimePurchase && user.ownedShopItemIDs.contains(id)
    }
}

// Daily Missions(not done yet)

public enum DailyRequirement: Codable, Hashable {
    case completeSubgoalCount(Int)
    case reflectionCount(Int)

    // Codable helpers since enum has associated values
    enum CodingKeys: String, CodingKey { case tag, value }
    enum Tag: String, Codable { case completeSubgoalCount, reflectionCount }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let tag = try container.decode(Tag.self, forKey: .tag)
        switch tag {
        case .completeSubgoalCount:
            let v = try container.decode(Int.self, forKey: .value)
            self = .completeSubgoalCount(v)
        case .reflectionCount:
            let v = try container.decode(Int.self, forKey: .value)
            self = .reflectionCount(v)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .completeSubgoalCount(let v):
            try container.encode(Tag.completeSubgoalCount, forKey: .tag)
            try container.encode(v, forKey: .value)
        case .reflectionCount(let v):
            try container.encode(Tag.reflectionCount, forKey: .tag)
            try container.encode(v, forKey: .value)
        }
    }
}

public struct DailyMission: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var rewardCoins: Int
    public var rewardXP: Int
    public var isCompletedToday: Bool
    public var requires: DailyRequirement

    public init(id: UUID = UUID(), title: String, rewardCoins: Int = 10, rewardXP: Int = 5, isCompletedToday: Bool = false, requires: DailyRequirement) {
        self.id = id
        self.title = title
        self.rewardCoins = rewardCoins
        self.rewardXP = rewardXP
        self.isCompletedToday = isCompletedToday
        self.requires = requires
    }
}

public struct Achievement: Identifiable, Hashable, Codable {
    public let id: UUID
    public var title: String
    public var description: String
    public var unlocked: Bool
    public var unlockedAt: Date?

    public init(id: UUID = UUID(), title: String, description: String, unlocked: Bool = false, unlockedAt: Date? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.unlocked = unlocked
        self.unlockedAt = unlockedAt
    }
}
