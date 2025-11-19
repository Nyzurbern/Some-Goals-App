//
//  AddReflectionView.swift
//  SomeGoalsApp
//
//  Created by Administrator on 19/11/25.
//

import SwiftUI

struct AddReflectionView: View {
    @Binding var Reflection: Reflection
    var body: some View {
        Text("Add reflection here")
        Form {
            Section(header: Text("Goal Details")) {
                TextField(
                    "What challenges or obstacles did I experience? How did I overcome them, or what prevented me from doing so?",
                    text: $Reflection.challenges
                )
                .textInputAutocapitalization(.sentences)
                TextField(
                    "What specific actions or habits contributed most to my progress?",
                    text: $Reflection.actionsorhabits
                )
                .textInputAutocapitalization(.sentences)
                TextField(
                    "What resources or support were most helpful?",
                    text: $Reflection.resourcesorsupport
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
