//
//  Color.swift
//  TheMillions
//
//  Created by Ryan J. W. Kim on 2022/01/19.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
    
    let logoColor = Color("LogoColor")
}
