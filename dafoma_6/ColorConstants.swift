//
//  ColorConstants.swift
//  ColorSync
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

// MARK: - ColorSync Color Palette
extension Color {
    // Background Colors
    static let csDeepRed = Color(hex: "#ae2d27")
    static let csSandyBeige = Color(hex: "#dfb492")
    static let csBrightYellow = Color(hex: "#ffc934")
    
    // Element/Button Colors
    static let csVibrantGreen = Color(hex: "#1ed55f")
    static let csNeonYellow = Color(hex: "#ffff03")
    static let csBoldRed = Color(hex: "#eb262f")
    
    // Initialize Color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // Convert Color to hex string
    var hexString: String {
        guard let components = UIColor(self).cgColor.components else { return "#000000" }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
    
    // Get RGB components
    var rgbComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }
    
    // Get HSL components
    var hslComponents: (hue: Double, saturation: Double, lightness: Double, alpha: Double) {
        let rgb = rgbComponents
        let max = Swift.max(rgb.red, rgb.green, rgb.blue)
        let min = Swift.min(rgb.red, rgb.green, rgb.blue)
        
        let lightness = (max + min) / 2
        
        guard max != min else {
            return (0, 0, lightness, rgb.alpha)
        }
        
        let delta = max - min
        let saturation = lightness > 0.5 ? delta / (2 - max - min) : delta / (max + min)
        
        var hue: Double = 0
        switch max {
        case rgb.red:
            hue = (rgb.green - rgb.blue) / delta + (rgb.green < rgb.blue ? 6 : 0)
        case rgb.green:
            hue = (rgb.blue - rgb.red) / delta + 2
        case rgb.blue:
            hue = (rgb.red - rgb.green) / delta + 4
        default:
            break
        }
        hue /= 6
        
        return (hue * 360, saturation * 100, lightness * 100, rgb.alpha * 100)
    }
}

// MARK: - ColorSync Palette Structure
struct ColorSyncPalette {
    static let backgrounds = [
        ("Deep Red", Color.csDeepRed, "#ae2d27"),
        ("Sandy Beige", Color.csSandyBeige, "#dfb492"),
        ("Bright Yellow", Color.csBrightYellow, "#ffc934")
    ]
    
    static let elements = [
        ("Vibrant Green", Color.csVibrantGreen, "#1ed55f"),
        ("Neon Yellow", Color.csNeonYellow, "#ffff03"),
        ("Bold Red", Color.csBoldRed, "#eb262f")
    ]
    
    static let allColors = backgrounds + elements
}

// MARK: - Color Combination Storage
struct ColorCombination: Codable, Identifiable {
    let id = UUID()
    let name: String
    let backgroundColor: String
    let elementColor: String
    let description: String
    let dateCreated: Date
}

// MARK: - UserDefaults Extension for ColorSync
extension UserDefaults {
    private enum Keys {
        static let savedCombinations = "ColorSyncSavedCombinations"
        static let preferredBackground = "ColorSyncPreferredBackground"
        static let showEducationalTips = "ColorSyncShowEducationalTips"
    }
    
    var savedCombinations: [ColorCombination] {
        get {
            guard let data = data(forKey: Keys.savedCombinations),
                  let combinations = try? JSONDecoder().decode([ColorCombination].self, from: data) else {
                return []
            }
            return combinations
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            set(data, forKey: Keys.savedCombinations)
        }
    }
    
    var preferredBackground: String {
        get { string(forKey: Keys.preferredBackground) ?? "#ae2d27" }
        set { set(newValue, forKey: Keys.preferredBackground) }
    }
    
    var showEducationalTips: Bool {
        get { bool(forKey: Keys.showEducationalTips) }
        set { set(newValue, forKey: Keys.showEducationalTips) }
    }
} 