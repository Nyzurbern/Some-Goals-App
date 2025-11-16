//
//  ShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

// ShopView.swift
// UI to browse and buy shop items (buildings + boosters)

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedCategory: ShopCategory = .buildings
    @State private var showNotEnough = false
    @State private var lastBought: String?

    var itemsForCategory: [ShopItem] {
        userData.shopItems.filter { $0.category == selectedCategory }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ShopCategory.allCases, id: \.self) { category in
                        Text(category.displayName).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                Text("Coins: \(userData.coins)").font(.headline).padding(.bottom, 4)

                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(itemsForCategory) { item in
                            VStack(spacing: 8) {
                                if let asset = item.assetName {
                                    Image(asset).resizable().scaledToFit().frame(height: 80)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.08))
                                        .frame(height: 80)
                                        .overlay(Text(item.title).font(.caption).multilineTextAlignment(.center).padding(6))
                                }

                                Text(item.description).font(.caption2).multilineTextAlignment(.center).lineLimit(3)

                                HStack {
                                    Text("\(item.price) coins").font(.caption).foregroundColor(.secondary)
                                    Spacer()
                                    if item.oneTimePurchase && userData.ownedShopItemIDs.contains(item.id) {
                                        Text("Owned").font(.caption2).foregroundColor(.green)
                                    }
                                }

                                Button(action: {
                                    if item.oneTimePurchase && userData.ownedShopItemIDs.contains(item.id) { return }
                                    let ok = userData.buyShopItem(item)
                                    if ok {
                                        lastBought = item.title
                                    } else {
                                        showNotEnough = true
                                    }
                                }) {
                                    Text(item.oneTimePurchase && userData.ownedShopItemIDs.contains(item.id) ? "Owned" : "Buy")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(item.oneTimePurchase && userData.ownedShopItemIDs.contains(item.id))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                        }
                    }
                    .padding()
                }

                if let last = lastBought {
                    Text("Bought: \(last)").font(.caption).foregroundColor(.secondary).padding(.bottom, 6)
                }
            }
            .navigationTitle("Shop")
            .alert("Not enough coins", isPresented: $showNotEnough) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Earn coins by completing subgoals and collecting production.")
            }
        }
    }
}
