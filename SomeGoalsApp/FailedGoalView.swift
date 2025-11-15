//
//  FailedGoalView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct FailedGoalView: View {
    
    @State private var textInput = ""
    
    var body: some View {
        Text("How does it feel to have achieved your goal? What were some limitations you faced and how did you overcome it?")
                    .frame(width: 350)
                    .bold()
                    .font(.title3)
        TextField("Your reflection...", text: $textInput)
            .textFieldStyle(.roundedBorder)
            .frame(width: 350)
        
    }
}

#Preview {
    FailedGoalView()
}

