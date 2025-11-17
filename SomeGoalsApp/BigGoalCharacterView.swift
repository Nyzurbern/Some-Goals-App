//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct BigGoalCharacterView: View {
    @State private var foodRectWidth: CGFloat = 30
    @State private var waterRectWidth: CGFloat = 30
    var body: some View {
        ScrollView{
            VStack{
                Text("Character")
                    .bold()
                    .font(.title)
                Image("subject nobody")
                HStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                    .stroke(Color.orange, lineWidth: 3)
                            )
                        HStack{
                            Rectangle()
                                .frame(width: foodRectWidth, height: 40)
                                .frame(maxWidth: 300, alignment: .leading)
                                .foregroundStyle(.orange)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("🍞")
                    }
                    Button{
                        print("Food is served")
                        if foodRectWidth < 300 {
                            foodRectWidth += 10
                        }
                    } label: {
                        Text("Feed")
                            .padding()
                            .background(.orange)
                            .foregroundStyle(.white)
                            .frame(height: 41.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                HStack{
                    ZStack{
                        Rectangle()
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.background)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                        HStack{
                            Rectangle()
                                .frame(width: waterRectWidth, height: 40)
                                .frame(maxWidth: 300, alignment: .leading)
                                .foregroundStyle(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        Text("💧")
                    }
                    Button{
                        print("Drinks are served")
                        print(waterRectWidth)
                        if waterRectWidth < 300 {
                            waterRectWidth += 10
                        }
                    } label: {
                        Text("Drink")
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .frame(height: 41.5)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
    }
}

#Preview {
    BigGoalCharacterView()
}
