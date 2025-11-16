//
//  UIHelper.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 17/11/25.
//

import SwiftUI

struct SimpleToast: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                VStack {
                    Text(message).padding(12).background(RoundedRectangle(cornerRadius: 10).fill(Color.black.opacity(0.85))).foregroundColor(.white)
                    Spacer()
                }.padding(.top, 40).zIndex(1000).transition(.move(edge: .top).combined(with: .opacity))
            }
        }.animation(.easeInOut, value: isPresented)
    }
}
extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        modifier(SimpleToast(isPresented: isPresented, message: message))
    }
}
