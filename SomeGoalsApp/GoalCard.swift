//
//  GoalCard.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct GoalCardView: View {
    let goal: Goal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                        .bold()
                    Text(goal.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Text(goal.percentString)
                    .bold()
            }

            Text("Deadline: \(goal.deadline.formatted(.dateTime.month().day().year()))")
                .font(.caption)
                .foregroundColor(goal.isOverdue ? .red : .secondary)

            ProgressView(value: goal.progressFraction)
                .frame(height: 8)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            if !goal.subgoals.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Sub-goals")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    ForEach(goal.subgoals.prefix(3)) { s in
                        HStack {
                            Text(s.title)
                                .font(.caption)
                            Spacer()
                            Text(s.isCompleted ? "✅" : "❌")
                                .font(.caption)
                        }
                    }
                    if goal.subgoals.count > 3 {
                        Text("…and \(goal.subgoals.count - 3) more")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 4)
    }
}
