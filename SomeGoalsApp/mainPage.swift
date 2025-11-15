//
//  mainPage.swift
//  SomeGoalsApp
//
//  Created by Administrator on 14/11/25.
//

import SwiftUI

struct mainPage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Big Goals")
                    .bold()
                    .padding()

            }
            HStack {
                NavigationLink {
                    createAGoal()
                } label: {
                    Text("Create a goal!")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            }
            Spacer()
        }
    }
}

#Preview {
    mainPage()
}
