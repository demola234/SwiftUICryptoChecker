//
//  ContentView.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                Text("Accent Color")
                    .foregroundColor(Color.theme.accent)
                Text("Green Color")
                    .foregroundColor(Color.theme.green)
                Text("Red Color")
                    .foregroundColor(Color.theme.red)
                Text("Secondary Text Color")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    ContentView()
}
