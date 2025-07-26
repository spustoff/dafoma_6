//
//  ColorMixerView.swift
//  ColorSync
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ColorMixerView: View {
    @State private var redValue: Double = 174
    @State private var greenValue: Double = 45
    @State private var blueValue: Double = 39
    @State private var selectedPalette = 0
    @State private var mixedColor = Color.csDeepRed
    @State private var showSaveSheet = false
    @State private var combinationName = ""
    @State private var combinationDescription = ""
    @AppStorage("savedCombinations") private var savedCombinations: Data = Data()
    
    let paletteOptions = ["Custom Mix", "Background Blend", "Element Harmony"]
    
    var computedColor: Color {
        Color(.sRGB, red: redValue/255, green: greenValue/255, blue: blueValue/255)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background gradient
                    LinearGradient(
                        colors: [Color.csSandyBeige.opacity(0.3), Color.csBrightYellow.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack(spacing: 25) {
                            // Live Color Preview
                            VStack(spacing: 20) {
                                Text("Color Laboratory")
                                    .font(.largeTitle.bold())
                                    .foregroundColor(.primary)
                                
                                // Color Preview Circle
                                Circle()
                                    .fill(computedColor)
                                    .frame(width: 200, height: 200)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                                    )
                                    .shadow(radius: 10)
                                    .animation(.easeInOut(duration: 0.3), value: computedColor)
                                
                                // Color Values Display
                                VStack(spacing: 8) {
                                    Text(computedColor.hexString)
                                        .font(.title2.monospaced().bold())
                                        .foregroundColor(.primary)
                                    
                                    HStack(spacing: 20) {
                                        Text("R: \(Int(redValue))")
                                        Text("G: \(Int(greenValue))")
                                        Text("B: \(Int(blueValue))")
                                    }
                                    .font(.caption.monospaced())
                                    .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )
                            
                            // Color Sliders
                            VStack(spacing: 20) {
                                Text("RGB Controls")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                VStack(spacing: 15) {
                                    ColorSlider(
                                        value: $redValue,
                                        range: 0...255,
                                        color: .red,
                                        label: "Red"
                                    )
                                    
                                    ColorSlider(
                                        value: $greenValue,
                                        range: 0...255,
                                        color: .green,
                                        label: "Green"
                                    )
                                    
                                    ColorSlider(
                                        value: $blueValue,
                                        range: 0...255,
                                        color: .blue,
                                        label: "Blue"
                                    )
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                            )
                            
                            // Palette Presets
                            VStack(spacing: 15) {
                                Text("Quick Presets")
                                    .font(.title2.bold())
                                    .foregroundColor(.primary)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                    ForEach(ColorSyncPalette.allColors, id: \.2) { colorData in
                                        Button(action: {
                                            let rgb = colorData.1.rgbComponents
                                            withAnimation(.spring()) {
                                                redValue = rgb.red * 255
                                                greenValue = rgb.green * 255
                                                blueValue = rgb.blue * 255
                                            }
                                        }) {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .fill(colorData.1)
                                                    .frame(width: 50, height: 50)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                                    )
                                                
                                                Text(colorData.0)
                                                    .font(.caption)
                                                    .foregroundColor(.primary)
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
                            
                            // Color Harmony Suggestions
                            ColorHarmonyView(baseColor: computedColor)
                            
                            // Save Combination Button
                            Button(action: {
                                showSaveSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "heart.fill")
                                    Text("Save Color Combination")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.csVibrantGreen)
                                .cornerRadius(15)
                            }
                            
                            Spacer(minLength: 100)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showSaveSheet) {
            SaveCombinationSheet(
                color: computedColor,
                name: $combinationName,
                description: $combinationDescription
            )
        }
        .onChange(of: [redValue, greenValue, blueValue]) { _ in
            mixedColor = computedColor
        }
    }
}

struct ColorSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(label)
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(Int(value))")
                    .font(.headline.monospaced())
                    .foregroundColor(.secondary)
            }
            
            Slider(value: $value, in: range)
                .accentColor(color)
                .animation(.easeInOut(duration: 0.1), value: value)
        }
    }
}

struct ColorHarmonyView: View {
    let baseColor: Color
    
    var complementaryColor: Color {
        let hsl = baseColor.hslComponents
        return Color(hue: (hsl.hue + 180).truncatingRemainder(dividingBy: 360) / 360,
                    saturation: hsl.saturation / 100,
                    brightness: hsl.lightness / 100)
    }
    
    var analogousColors: [Color] {
        let hsl = baseColor.hslComponents
        return [
            Color(hue: (hsl.hue + 30).truncatingRemainder(dividingBy: 360) / 360,
                 saturation: hsl.saturation / 100,
                 brightness: hsl.lightness / 100),
            Color(hue: (hsl.hue - 30).truncatingRemainder(dividingBy: 360) / 360,
                 saturation: hsl.saturation / 100,
                 brightness: hsl.lightness / 100)
        ]
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Color Harmony")
                .font(.title2.bold())
                .foregroundColor(.primary)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Complementary")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    Circle()
                        .fill(complementaryColor)
                        .frame(width: 30, height: 30)
                }
                
                HStack {
                    Text("Analogous")
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    HStack(spacing: 5) {
                        ForEach(analogousColors.indices, id: \.self) { index in
                            Circle()
                                .fill(analogousColors[index])
                                .frame(width: 25, height: 25)
                        }
                    }
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

struct SaveCombinationSheet: View {
    let color: Color
    @Binding var name: String
    @Binding var description: String
    @Environment(\.dismiss) private var dismiss
    @AppStorage("savedCombinations") private var savedCombinationsData: Data = Data()
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header with Cancel/Save buttons
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                Text("Save Combination")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Button("Save") {
                    saveCombination()
                    dismiss()
                }
                .foregroundColor(name.isEmpty ? .gray : .blue)
                .disabled(name.isEmpty)
            }
            .padding()
            .background(Color(.systemGray6))
            
            VStack(spacing: 25) {
                Circle()
                    .fill(color)
                    .frame(width: 100, height: 100)
                    .shadow(radius: 5)
                
                VStack(spacing: 15) {
                    TextField("Combination Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Description (optional)", text: $description)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func saveCombination() {
        let combination = ColorCombination(
            name: name,
            backgroundColor: color.hexString,
            elementColor: color.hexString,
            description: description.isEmpty ? "Custom mixed color" : description,
            dateCreated: Date()
        )
        
        var combinations = UserDefaults.standard.savedCombinations
        combinations.append(combination)
        UserDefaults.standard.savedCombinations = combinations
        
        name = ""
        description = ""
    }
}

#Preview {
    ColorMixerView()
} 
