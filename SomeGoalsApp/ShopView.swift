//
//  ShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userData: UserData

    @State private var ownedItems: Set<String> = []
    @State private var showNotEnoughAlert: Bool = false

    let items = [
        ("Avatar Hat", 100),
        ("Avatar Jacket", 200),
        ("Background Theme", 300),
        ("Special Badge", 500)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Shop / Rewards")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)

                    Text("Coins: \(userData.coins)")
                        .font(.title2)
                        .foregroundStyle(.yellow)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(items, id: \.0) { item in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(height: 120)
                                    .overlay(Text(item.0).bold())
                                Text("\(item.1) coins")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button(ownedItems.contains(item.0) ? "Owned" : "Buy") {
                                    if ownedItems.contains(item.0) { return }
                                    let price = item.1
                                    let ok = userData.spendCoins(price)
                                    if ok {
                                        ownedItems.insert(item.0)
                                    } else {
                                        showNotEnoughAlert = true
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(ownedItems.contains(item.0))
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Shop")
            .alert("Not enough coins", isPresented: $showNotEnoughAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Earn coins by completing sub-goals and goals.")
            }
        }
    }
}
