//
//  ColorShowcaseView.swift
//  ColorSync
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ColorShowcaseView: View {
    @State private var currentBackgroundIndex = 0
    @State private var isAnimating = false
    @State private var selectedColor = Color.csDeepRed
    @State private var showColorDetails = false
    
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic Background
                LinearGradient(
                    colors: [
                        ColorSyncPalette.backgrounds[currentBackgroundIndex].1,
                        ColorSyncPalette.backgrounds[currentBackgroundIndex].1.opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1.5), value: currentBackgroundIndex)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 15) {
                            Text("ColorSync")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .shadow(radius: 2)
                            
                            Text("Professional Color Palette for Developers")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.9))
                                .multilineTextAlignment(.center)
                                .shadow(radius: 1)
                        }
                        .padding(.top, 20)
                        
                        // Background Colors Section
                        VStack(spacing: 20) {
                            HStack {
                                Text("Background Colors")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                                ForEach(Array(ColorSyncPalette.backgrounds.enumerated()), id: \.offset) { index, color in
                                    ColorCard(
                                        name: color.0,
                                        color: color.1,
                                        hexCode: color.2,
                                        isSelected: index == currentBackgroundIndex
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            currentBackgroundIndex = index
                                            selectedColor = color.1
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Element Colors Section
                        VStack(spacing: 20) {
                            HStack {
                                Text("Element Colors")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
                                ForEach(Array(ColorSyncPalette.elements.enumerated()), id: \.offset) { index, color in
                                    ColorCard(
                                        name: color.0,
                                        color: color.1,
                                        hexCode: color.2
                                    )
                                    .onTapGesture {
                                        selectedColor = color.1
                                        showColorDetails = true
                                    }
                                }
                            }
                        }
                        
                        // Color Harmony Demonstration
                        VStack(spacing: 20) {
                            HStack {
                                Text("Color Harmony Preview")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            
                            HStack(spacing: 15) {
                                ForEach(ColorSyncPalette.elements, id: \.2) { element in
                                    VStack {
                                        Circle()
                                            .fill(element.1)
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Circle()
                                                    .stroke(ColorSyncPalette.backgrounds[currentBackgroundIndex].1, lineWidth: 3)
                                            )
                                            .shadow(radius: 3)
                                        
                                        Text(element.0)
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 1.5)) {
                currentBackgroundIndex = (currentBackgroundIndex + 1) % ColorSyncPalette.backgrounds.count
            }
        }
        .sheet(isPresented: $showColorDetails) {
            ColorDetailSheet(color: selectedColor)
        }
    }
}

struct ColorCard: View {
    let name: String
    let color: Color
    let hexCode: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
                )
                .shadow(radius: isSelected ? 8 : 4)
                .scaleEffect(isSelected ? 1.05 : 1.0)
            
            VStack(spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(hexCode)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isSelected)
    }
}

struct ColorDetailSheet: View {
    let color: Color
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header with Done button
            HStack {
                Spacer()
                
                Text("Color Details")
                    .font(.headline.weight(.semibold))
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            
            VStack(spacing: 25) {
                // Color Preview
                RoundedRectangle(cornerRadius: 25)
                    .fill(color)
                    .frame(height: 200)
                    .shadow(radius: 10)
                
                // Color Information
                VStack(spacing: 15) {
                    Group {
                        ColorInfoRow(label: "HEX", value: color.hexString)
                        ColorInfoRow(label: "RGB", value: String(format: "%.0f, %.0f, %.0f", 
                                                               color.rgbComponents.red * 255,
                                                               color.rgbComponents.green * 255,
                                                               color.rgbComponents.blue * 255))
                        ColorInfoRow(label: "HSL", value: String(format: "%.0f°, %.0f%%, %.0f%%",
                                                               color.hslComponents.hue,
                                                               color.hslComponents.saturation,
                                                               color.hslComponents.lightness))
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemGray6))
                )
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ColorInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.headline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .monospaced).weight(.medium))
        }
    }
}

#Preview {
    ColorShowcaseView()
} 
