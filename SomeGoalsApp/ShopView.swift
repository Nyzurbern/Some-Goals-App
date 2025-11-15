//
//  ShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct ShopView: View {
    @EnvironmentObject var userData: UserData
    
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
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(height: 120)
                                    .overlay(Text(item.0).bold())
                                Text("\(item.1) coins")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button("Buy") {
                                    if userData.coins >= item.1 {
                                        userData.coins -= item.1
                                        // handle buy: unlock or mark owned
                                    } else {
                                        // insufficient coins - could show alert
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ShopView().environmentObject(UserData(sample: true))
}
