//
//  ShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct DrinksShopView: View {
    @EnvironmentObject var userData: UserData
    @StateObject var ViewModel: GoalViewModel
      
    let items = [
        Consumable(name: "Water", dftype: "Drink", image: "subject nobody", cost: 10, fillAmount: 30),
        Consumable(name: "Coffee", dftype: "Drink", image: "subject nobody", cost: 20, fillAmount: 50),
        Consumable(name: "Clorox", dftype: "Drink", image: "subject nobody", cost: 30, fillAmount: 30)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Drinks Shop")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)
                    
                    Text("Coins: \(ViewModel.goal.coins)")
                        .font(.title2)
                        .foregroundStyle(.yellow)
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(height: 120)
                                    .overlay(Text(item.name).bold())
                                Text("\(item.cost) coins")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button("Buy") {
                                    if ViewModel.goal.coins >= item.cost {
                                        ViewModel.goal.coins -= item.cost
                                    } else {
                                        
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

//#Preview {
//    DrinksShopView().environmentObject(UserData(sample: true))
//}
