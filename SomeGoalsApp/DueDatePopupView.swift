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
    @State private var active: ActiveAction?

    private enum ActiveAction: Identifiable {
        case extend, reflect
        var id: Int { self == .extend ? 1 : 2 }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("This goal is overdue or nearing deadline. Choose an action.")
                    .font(.headline).multilineTextAlignment(.center).padding()
                HStack(spacing: 12) {
                    Button(role: .destructive) {
                        if let idx = userData.goals.firstIndex(where: { $0.id == goalID }) {
                            var g = userData.goals[idx]
                            g.status = .expired
                            userData.updateGoal(g)
                        }
                        dismiss()
                    } label: {
                        Text("Fail it").frame(maxWidth: .infinity).padding().background(RoundedRectangle(cornerRadius: 10).fill(Color.red)).foregroundStyle(.white)
                    }
                    Button { active = .extend } label: {
                        Text("Extend date").frame(maxWidth: .infinity).padding().background(RoundedRectangle(cornerRadius: 10).fill(Color.yellow)).foregroundStyle(.white)
                    }
                }
                Button { active = .reflect } label: {
                    Text("I completed it (reflect)").frame(maxWidth: .infinity).padding().background(RoundedRectangle(cornerRadius: 10).fill(Color.green)).foregroundStyle(.white)
                }
                Spacer()
            }.padding().navigationTitle("Deadline Actions")
            .sheet(item: $active) { act in
                switch act {
                case .extend: ExtendDueDateView(goalID: goalID).environmentObject(userData)
                case .reflect: FailOrSuccessView(goalID: goalID).environmentObject(userData)
                }
            }
        }
    }
}
