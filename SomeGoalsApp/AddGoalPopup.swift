//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddGoalPopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var GoalDeadline: Date = Date()
    @State private var reward: Int = 50
    @State private var image: String = "subject nobody"
    @State private var profileImage: String = "Subject 3"
    @State private var CharacterPicked: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Short description", text: $description)
                        .textInputAutocapitalization(.sentences)
                    DatePicker("Deadline", selection: $GoalDeadline, displayedComponents: .date)
                }
                
                Section(header: Text("Reward")) {
                    Text("Coin reward: \(reward)")
                }
                
                Section(header: Text("Character")) {
                    ScrollView(.horizontal) {
                        HStack {
                            Button{
                                image = "subject nobody"
                                profileImage = "Subject 3"
                                CharacterPicked=1
                            }label: {
                                Image("Subject 3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay {
                                        if CharacterPicked == 1 {
                                            Circle().stroke(.blue, lineWidth: 4)
                                        }
                                    }
                            }
                            Button{
                                image = "subject nobody"
                                profileImage = "Subject 3"
                                CharacterPicked=2
                            }label: {
                                Image("Subject 3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay {
                                        if CharacterPicked == 2 {
                                            Circle().stroke(.blue, lineWidth: 4)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let g = Goal(
                            title: title,
                            description: description,
                            deadline: GoalDeadline,
                            subgoals: [],
                            reflections: [],
                            character: Character(profileImage: profileImage, image: image, waterLevel: 30, foodLevel: 30),
                            coins: 10,
                            foodprogressbar: 30,
                            drinksprogressbar: 30 
                        )
                        userData.goals.append(g)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AddGoalPopupView()
        .environmentObject(UserData(sample: true))
}
