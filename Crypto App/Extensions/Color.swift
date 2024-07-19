//
//  Color.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import Foundation
import SwiftUI

extension Color {
    static let theme =  ColorTheme()
    static let launch = LaunchTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColoring")
    let red = Color("RedColoring")
    let secondaryText = Color("SecondaryTextColor")
}


struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
