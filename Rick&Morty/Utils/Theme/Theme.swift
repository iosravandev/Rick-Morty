//
//  Theme.swift
//  Rick&Morty
//
//  Created by Nihad Ismayilov on 01.11.24.
//

import UIKit

enum Theme: String {
    case light
    case dark
    
    var interfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    static func save(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: "selectedTheme")
    }

    static func load() -> Theme {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme")
        return Theme(rawValue: savedTheme ?? "light") ?? .light
    }
}
