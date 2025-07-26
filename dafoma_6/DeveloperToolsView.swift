//
//  DeveloperToolsView.swift
//  ColorSync
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct DeveloperToolsView: View {
    @State private var selectedColor = Color.csDeepRed
    @State private var inputHex = "#ae2d27"
    @State private var showingColorPicker = false
    @State private var codeSnippetType = 0
    @State private var showingExportSheet = false
    
    let snippetTypes = ["SwiftUI", "UIKit", "CSS", "Android XML"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Developer Tools")
                            .font(.largeTitle.bold())
                            .foregroundColor(.primary)
                        
                        Text("Professional color utilities for developers")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top)
                    
                    // Color Input Section
                    VStack(spacing: 20) {
                        Text("Color Input")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 15) {
                            HStack {
                                TextField("Enter HEX color", text: $inputHex)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onChange(of: inputHex) { newValue in
                                        if newValue.hasPrefix("#") && newValue.count == 7 {
                                            selectedColor = Color(hex: newValue)
                                        }
                                    }
                                
                                Button("Pick") {
                                    showingColorPicker = true
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.csVibrantGreen)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                            
                            // Color Preview
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedColor)
                                .frame(height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // Color Conversion Section
                    ColorConversionView(color: selectedColor)
                    
                    // Code Snippets Section
                    VStack(spacing: 20) {
                        Text("Code Snippets")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        Picker("Code Type", selection: $codeSnippetType) {
                            ForEach(snippetTypes.indices, id: \.self) { index in
                                Text(snippetTypes[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        CodeSnippetView(color: selectedColor, type: snippetTypes[codeSnippetType])
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    
                    // ColorSync Palette Quick Access
                    QuickPaletteView(selectedColor: $selectedColor, inputHex: $inputHex)
                    
                    // Export Options
                    VStack(spacing: 15) {
                        Text("Export Options")
                            .font(.title2.bold())
                            .foregroundColor(.primary)
                        
                        VStack(spacing: 10) {
                            ExportButton(title: "Export as SwiftUI Extension", icon: "swift") {
                                showingExportSheet = true
                            }
                            
                            ExportButton(title: "Copy Color Palette JSON", icon: "doc.on.doc") {
                                copyPaletteJSON()
                            }
                            
                            ExportButton(title: "Generate CSS Variables", icon: "chevron.left.forwardslash.chevron.right") {
                                copyCSSVariables()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
                    
                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPicker("Select Color", selection: $selectedColor)
                .padding()
                .onChange(of: selectedColor) { newColor in
                    inputHex = newColor.hexString
                }
        }
        .sheet(isPresented: $showingExportSheet) {
            ExportSheet()
        }
    }
    
    private func copyPaletteJSON() {
        let palette: [String: [[String: String]]] = [
            "backgrounds": ColorSyncPalette.backgrounds.map { ["name": $0.0, "hex": $0.2] },
            "elements": ColorSyncPalette.elements.map { ["name": $0.0, "hex": $0.2] }
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: palette, options: .prettyPrinted)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                UIPasteboard.general.string = jsonString
            }
        } catch {
            print("Error creating JSON: \(error)")
        }
    }
    
    private func copyCSSVariables() {
        var cssVars = ":root {\n"
        for (name, _, hex) in ColorSyncPalette.backgrounds {
            let varName = "--cs-" + name.lowercased().replacingOccurrences(of: " ", with: "-")
            cssVars += "  \(varName): \(hex);\n"
        }
        for (name, _, hex) in ColorSyncPalette.elements {
            let varName = "--cs-" + name.lowercased().replacingOccurrences(of: " ", with: "-")
            cssVars += "  \(varName): \(hex);\n"
        }
        cssVars += "}"
        
        UIPasteboard.general.string = cssVars
    }
}

struct ColorConversionView: View {
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Color Conversions")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                ConversionRow(label: "HEX", value: color.hexString)
                ConversionRow(label: "RGB", value: String(format: "rgb(%.0f, %.0f, %.0f)",
                                                         color.rgbComponents.red * 255,
                                                         color.rgbComponents.green * 255,
                                                         color.rgbComponents.blue * 255))
                ConversionRow(label: "HSL", value: String(format: "hsl(%.0f°, %.0f%%, %.0f%%)",
                                                         color.hslComponents.hue,
                                                         color.hslComponents.saturation,
                                                         color.hslComponents.lightness))
                ConversionRow(label: "SwiftUI", value: String(format: "Color(.sRGB, red: %.3f, green: %.3f, blue: %.3f)",
                                                            color.rgbComponents.red,
                                                            color.rgbComponents.green,
                                                            color.rgbComponents.blue))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ConversionRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: {
                UIPasteboard.general.string = value
            }) {
                Image(systemName: "doc.on.doc")
                    .foregroundColor(Color.csVibrantGreen)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CodeSnippetView: View {
    let color: Color
    let type: String
    
    var codeSnippet: String {
        switch type {
        case "SwiftUI":
            return """
            extension Color {
                static let customColor = Color(.sRGB, red: \(String(format: "%.3f", color.rgbComponents.red)), green: \(String(format: "%.3f", color.rgbComponents.green)), blue: \(String(format: "%.3f", color.rgbComponents.blue)))
            }
            
            // Usage
            Text("Hello World")
                .foregroundColor(.customColor)
            """
        case "UIKit":
            return """
            extension UIColor {
                static let customColor = UIColor(red: \(String(format: "%.3f", color.rgbComponents.red)), green: \(String(format: "%.3f", color.rgbComponents.green)), blue: \(String(format: "%.3f", color.rgbComponents.blue)), alpha: 1.0)
            }
            
            // Usage
            label.textColor = .customColor
            """
        case "CSS":
            return """
            :root {
                --custom-color: \(color.hexString);
                --custom-color-rgb: \(Int(color.rgbComponents.red * 255)), \(Int(color.rgbComponents.green * 255)), \(Int(color.rgbComponents.blue * 255));
            }
            
            .custom-text {
                color: var(--custom-color);
                background-color: rgba(var(--custom-color-rgb), 0.1);
            }
            """
        case "Android XML":
            return """
            <resources>
                <color name="custom_color">\(color.hexString)</color>
            </resources>
            
            <!-- Usage in layout -->
            <TextView
                android:textColor="@color/custom_color"
                android:text="Hello World" />
            """
        default:
            return "Code snippet not available"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(type)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Button("Copy") {
                    UIPasteboard.general.string = codeSnippet
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.csVibrantGreen)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            ScrollView {
                Text(codeSnippet)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
            }
            .frame(maxHeight: 150)
        }
    }
}

struct QuickPaletteView: View {
    @Binding var selectedColor: Color
    @Binding var inputHex: String
    
    var body: some View {
        VStack(spacing: 15) {
            Text("ColorSync Palette")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(ColorSyncPalette.allColors, id: \.2) { colorData in
                    Button(action: {
                        selectedColor = colorData.1
                        inputHex = colorData.2
                    }) {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorData.1)
                                .frame(height: 60)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedColor == colorData.1 ? Color.primary : Color.clear, lineWidth: 2)
                                )
                            
                            VStack(spacing: 2) {
                                Text(colorData.0)
                                    .font(.caption.bold())
                                    .foregroundColor(.primary)
                                
                                Text(colorData.2)
                                    .font(.caption2.monospaced())
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ExportButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ExportSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var swiftUIExtension: String {
        """
        import SwiftUI
        
        extension Color {
            // ColorSync Background Colors
            static let csDeepRed = Color(hex: "#ae2d27")
            static let csSandyBeige = Color(hex: "#dfb492")
            static let csBrightYellow = Color(hex: "#ffc934")
            
            // ColorSync Element Colors
            static let csVibrantGreen = Color(hex: "#1ed55f")
            static let csNeonYellow = Color(hex: "#ffff03")
            static let csBoldRed = Color(hex: "#eb262f")
            
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
        }
        """
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header with Done button
            HStack {
                Spacer()
                
                Text("Export Code")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.blue)
                .font(.body.weight(.semibold))
            }
            .padding()
            .background(Color(.systemGray6))
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("SwiftUI Color Extension")
                        .font(.title2.bold())
                        .foregroundColor(.primary)
                    
                    Text(swiftUIExtension)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    
                    Button("Copy to Clipboard") {
                        UIPasteboard.general.string = swiftUIExtension
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.csVibrantGreen)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
            }
        }
    }
}

#Preview {
    DeveloperToolsView()
} 
