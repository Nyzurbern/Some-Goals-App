//
//  ExtendDueDateView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct ExtendDueDateView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    let goalID: UUID
    @State private var daysToAdd: Int = 1

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Extend by \(daysToAdd) day(s)", value: $daysToAdd, in: 1...30)
                Button("Apply Extension") {
                    userData.extendDeadline(for: goalID, byDays: daysToAdd)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
            .navigationTitle("Extend Deadline")
        }
    }
}
