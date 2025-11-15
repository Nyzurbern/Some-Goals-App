//
//  FailedGoalView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//
import SwiftUI

struct FailOrSuccessView: View {
    @State private var reflection = ""
    var body: some View {
        VStack {
            Text("How does it feel to have achieved your goal? What were some limitations you faced and how did you overcome it?")
                .frame(width: 350)
                .bold()
                .font(.title3)
            
            TextField("Your reflection..", text: $reflection)
                .frame(width: 350)
                .textFieldStyle(.roundedBorder)
        }
        .padding(40)
    
        Text("See how far your character has come!")
            .frame(width: 350)
            .bold()
            .font(.title3)

    }
}

#Preview {
    FailOrSuccessView()
}
