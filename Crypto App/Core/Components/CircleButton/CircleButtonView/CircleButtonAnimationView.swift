//
//  CircleButtonAnimationView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool
    var body: some View {
       Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(animate ? Animation.easeOut(duration: 1.0) : .none, value: true)
    }
}

#Preview {
    CircleButtonAnimationView(animate: .constant(true))
        .foregroundColor(Color.theme.accent)
        .frame(width: 100, height: 100)
}
