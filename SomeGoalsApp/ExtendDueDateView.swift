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
    @State private var days: Int = 1

    var body: some View {
        NavigationStack {
            Form {
                Stepper("Extend by \(days) day(s)", value: $days, in: 1...30)
                Button("Apply") {
                    userData.extendDeadline(for: goalID, byDays: days)
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }.navigationTitle("Extend Deadline")
        }
    }
}
