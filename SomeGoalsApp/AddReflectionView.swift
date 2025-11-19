//
//  AddReflectionView.swift
//  SomeGoalsApp
//
//  Created by Administrator on 19/11/25.
//

import SwiftUI

struct AddReflectionView: View {
    @Binding var goal: Goal
    var body: some View {
        Text("Add reflection here")
        Form {
            Section(header: Text("Goal Details")) {
                Text("What challenges or obstacles did I experience? How did I overcome them, or what prevented me from doing so?")
                TextField(
                    "Type here...",
                    text: $goal.challenges
                )
                .textInputAutocapitalization(.sentences)
                Text("What specific actions or habits contributed most to my progress?")
                TextField(
                    "Type here...",
                    text: $goal.actionsorhabits
                )
                .textInputAutocapitalization(.sentences)
                Text("What resources or support were most helpful?")
                TextField(
                    "Type here...",
                    text: $goal.resourcesorsupport
                )
            }

        }
    }
}

//    #Preview {
//        AddReflectionView()
//    }
//
//}
