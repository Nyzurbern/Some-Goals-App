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
    @State private var deadline: Date = Date()
    @State private var reward: Int = 50
    @State private var selectedCharacterIndex: Int = 0
    
    // nitin improved character selection
    private let characterOptions = [
        Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30),
        Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30)
        // can add more chars easily now ig
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    
                    TextField("Short description", text: $description)
                        .textInputAutocapitalization(.sentences)
                    
                    DatePicker("Deadline",
                             selection: $deadline,
                             in: Date()...,
                             displayedComponents: .date)
                }
                
                Section(header: Text("Reward")) {
                    Text("Coin reward: \(reward)")
                }
                
                Section(header: Text("Character")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(characterOptions.indices, id: \.self) { index in
                                Button {
                                    selectedCharacterIndex = index
                                } label: {
                                    VStack {
                                        Image(characterOptions[index].profileImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedCharacterIndex == index ?
                                                           Color.blue : Color.clear, lineWidth: 3)
                                            )
                                        
                                        Text("Character \(index + 1)")
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    .frame(height: 100)
                }
            }
            .navigationTitle("Add Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addGoal()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func addGoal() {
        let newGoal = Goal(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            deadline: deadline,
            subgoals: [],
            reflections: [],
            character: characterOptions[selectedCharacterIndex]
        )
        userData.goals.append(newGoal)
        dismiss()
    }
}
    #Preview {
        AddGoalPopupView()
            .environmentObject(UserData(sample: true))
    }
