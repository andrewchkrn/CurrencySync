//
//  TopAlert.swift
//  CurrencySync
//
//  Created by Andrew Trach on 06.04.2025.
//

import SwiftUI

struct TopAlert: ViewModifier {
    @StateObject var monitor = Monitor.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if monitor.status == .disconnected {
                VStack {
                    HStack() {
                        Spacer()
                        VStack(alignment: .center, spacing: Constant.spacingBetweenElements) {
                            HStack {
                                Text(verbatim: "No Internet Connection")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                    }
                    .frame(height: Constant.heightView, alignment: .bottom)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .red.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                    .background(.thinMaterial.opacity(0.6))
                    .cornerRadius(8)
                    
                    Spacer()
                }
                .padding(.vertical, -Constant.verticalPadding)
                .padding(.horizontal, -Constant.paddingMedium)
                .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

extension TopAlert {
    enum Constant {
        static let paddingMedium: CGFloat = 10.0
        static let heightView: CGFloat = 80.0
        static let verticalPadding: CGFloat = 62.0
        static let spacingBetweenElements: CGFloat = 2.0
    }
}


extension View {
    func topConnectionAlert() -> some View {
        self.modifier(TopAlert())
    }
}
