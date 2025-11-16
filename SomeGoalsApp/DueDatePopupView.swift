//
//  DueDatePopupView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct DueDatePopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    let goalID: UUID

    private enum ActiveAction: Identifiable {
        case extend, reflect
        var id: Int {
            switch self {
            case .extend: return 1
            case .reflect: return 2
            }
        }
    }

    @State private var activeAction: ActiveAction?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("This goal is overdue or nearing deadline.")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()

                HStack(spacing: 12) {
                    Button(role: .destructive) {
                        // mark failed/expired permanently using UserData API
                        userData.markGoalExpired(goalID)
                        dismiss()
                    } label: {
                        Text("Fail it")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
                            .foregroundStyle(.white)
                    }

                    Button {
                        activeAction = .extend
                    } label: {
                        Text("Extend date")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow))
                            .foregroundStyle(.white)
                    }
                }

                Button {
                    activeAction = .reflect
                } label: {
                    Text("I completed it (reflect)")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                        .foregroundStyle(.white)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Deadline Actions")
            .sheet(item: $activeAction) { action in
                switch action {
                case .extend:
                    ExtendDueDateView(goalID: goalID)
                        .environmentObject(userData)
                case .reflect:
                    FailOrSuccessView(goalID: goalID)
                        .environmentObject(userData)
                }
            }
        }
    }
}
