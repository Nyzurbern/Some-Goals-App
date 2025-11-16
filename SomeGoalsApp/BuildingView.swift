//
//  BuildingView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 17/11/25.
//

import SwiftUI

struct BuildingView: View {
    @EnvironmentObject var userData: UserData
    let building: Building
    @State private var showUpgradeFail = false
    @State private var collected: Int = 0
    @State private var showCollected = false

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.06))
                .frame(height: 110)
                .overlay(
                    VStack(spacing: 6) {
                        Text(building.type.displayName)
                            .bold()
                            .multilineTextAlignment(.center)

                        Text("Lv \(building.level)")
                            .font(.caption2)

                        if let up = building.upgradeCompletionAt, up > Date() {
                            Text("Upgrading until \(up.formatted(.dateTime.hour().minute()))")
                                .font(.caption2)
                                .foregroundColor(.orange)
                        } else {
                            Text("\(Int(building.productionPerHour()))/hr")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal, 8)
                )

            HStack {
                Button("Collect") {
                    collected = userData.collectFromBuilding(building.id)
                    showCollected = true
                }
                .buttonStyle(.bordered)

                Spacer()

                Button("Upgrade (\(building.upgradeCost()))") {
                    let ok = userData.startUpgradeBuilding(building.id)
                    if !ok { showUpgradeFail = true }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 6)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
        .alert("Not enough coins", isPresented: $showUpgradeFail) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Earn coins to upgrade.")
        }
        .alert(collected > 0 ? "Collected" : "Nothing", isPresented: $showCollected) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(collected > 0 ? "+\(collected) coins" : "No coins to collect")
        }
    }
}
