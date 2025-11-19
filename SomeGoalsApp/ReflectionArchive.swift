//
//  ReflectionView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct ReflectionArchive: View {
    @EnvironmentObject var userData: UserData
    @State private var selectedIndex: Int = 0
    @State private var newReflection: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Reflection Journal")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)
                
                if $userData.goals.isEmpty {
                    Text("No goals yet. Add a goal from Home to start reflecting.")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                } else {
                    if 0 == 0 {
                    }
                        
                    }
            }
        }
    }
}

#Preview {
    ReflectionArchive().environmentObject(UserData(sample: true))
}
