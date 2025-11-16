//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddGoalPopupView: View {
    @Environment(\.dismiss) private var dismiss

    var onAdd: (Goal) -> Void

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var deadline: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var selectedCharacterIndex: Int = 0

    private let characterOptions = [
        CharacterModel(profileImage: "Subject 3", image: "subject nobody"),
        CharacterModel(profileImage: "Subject 3", image: "subject nobody")
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section("Goal Details") {
                    TextField("Title", text: $title)
                    TextField("Short description", text: $description)
                    DatePicker("Deadline", selection: $deadline, in: Date()..., displayedComponents: .date)
                }

                Section("Character") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(characterOptions.indices, id: \.self) { i in
                                let c = characterOptions[i]
                                Button {
                                    selectedCharacterIndex = i
                                } label: {
                                    VStack {
                                        Image(c.profileImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(selectedCharacterIndex == i ? Color.blue : Color.clear, lineWidth: 3))
                                        Text("Char \(i+1)").font(.caption)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let new = Goal(title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                       description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                                       deadline: deadline,
                                       subgoals: [],
                                       character: characterOptions[selectedCharacterIndex])
                        onAdd(new)
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
