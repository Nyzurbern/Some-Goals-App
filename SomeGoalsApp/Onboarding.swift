//
//  Onboarding.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 17/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userData: UserData
    let onFinish: () -> Void

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Island of Progress",
            description: "Track your personal goals and watch your island grow as you accomplish them.",
            systemImage: "target.circle.fill",
            gradient: LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing),
            buttonColor: Color.purple
        ),
        OnboardingPage(
            title: "Set & Track Goals",
            description: "Add your goals, monitor progress, and earn rewards for every milestone you complete.",
            systemImage: "checkmark.circle.fill",
            gradient: LinearGradient(colors: [Color.orange, Color.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
            buttonColor: Color.pink
        ),
        OnboardingPage(
            title: "Grow Your Island",
            description: "Use coins and XP to build and upgrade your island. Every building represents your achievements!",
            systemImage: "house.fill",
            gradient: LinearGradient(colors: [Color.green, Color.teal], startPoint: .topLeading, endPoint: .bottomTrailing),
            buttonColor: Color.teal
        ),
        OnboardingPage(
            title: "Let's Get Started!",
            description: "Start your journey, complete goals, and build your progress island today!",
            systemImage: "sparkles",
            gradient: LinearGradient(colors: [Color.pink, Color.orange], startPoint: .topLeading, endPoint: .bottomTrailing),
            buttonColor: Color.orange
        )
    ]

    var body: some View {
        ZStack {
            pages[currentPage].gradient
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()
                
                Image(systemName: pages[currentPage].systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(.white)
                    .shadow(radius: 10)

                VStack(spacing: 12) {
                    Text(pages[currentPage].title)
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    Text(pages[currentPage].description)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 10, height: 10)
                    }
                }

                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onFinish()
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.white)
                        .foregroundColor(pages[currentPage].buttonColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 30)
                }

                Spacer()
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
    let gradient: LinearGradient
    let buttonColor: Color
}

#Preview {
    OnboardingView {}.environmentObject(UserData(sample: true))
}
