//
//  goalDue.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct GoalDuePopupView: View {

    var body: some View {
        VStack {
            
            Text("GOAL")
            Text("IS DUE!!!")
         
        }
        .bold()
        .foregroundStyle(.red)
        .font(.title)
        
        Text("How's your progress?")
            .foregroundStyle(.red)
        
        VStack {
            NavigationLink("I didn't manage to achieve it...", destination: FailedGoalView())
            Button("I didn't manage to achieve it...", action: {
            })
                .tint(.red)
            Button("I need.... MORE TIME!!!🕰️", action: {})
                .tint(.yellow)
            Button("I DID IT😍💪 #worlddomination", action: {})
                .tint(.green)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    GoalDuePopupView()
}
