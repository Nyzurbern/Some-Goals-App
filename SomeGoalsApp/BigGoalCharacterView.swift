//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct BigGoalCharacterView: View {
    @State private var foodRectWidth: CGFloat = 100
    @State private var waterRectWidth: CGFloat = 100

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Character").font(.title).bold()
                Image("subject nobody").resizable().scaledToFit().frame(height: 200)
                statusBar(label: "🍞", width: $foodRectWidth, color: .orange, action: {
                    if foodRectWidth < 300 { foodRectWidth += 20 }
                })
                statusBar(label: "💧", width: $waterRectWidth, color: .blue, action: {
                    if waterRectWidth < 300 { waterRectWidth += 20 }
                })
                Spacer()
            }
            .padding()
        }
    }

    @ViewBuilder
    private func statusBar(label: String, width: Binding<CGFloat>, color: Color, action: @escaping ()->Void) -> some View {
        HStack {
            ZStack {
                Rectangle().frame(width: 300, height: 40).foregroundStyle(.background)
                    .overlay(RoundedRectangle(cornerRadius: 8).inset(by: 1.5).stroke(color, lineWidth: 3))
                HStack {
                    Rectangle()
                        .frame(width: width.wrappedValue, height: 40)
                        .frame(maxWidth: 300, alignment: .leading)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                Text(label)
            }
            Button {
                action()
            } label: {
                Text(label == "🍞" ? "Feed" : "Drink")
                    .padding()
                    .background(color)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}
