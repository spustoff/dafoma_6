//
//  EducationalView.swift
//  ColorSync
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct EducationalView: View {
    @State private var selectedSection = 0
    
    let sections = ["Color Theory", "Psychology", "Design Tips", "Accessibility"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 10) {
                    Text("Color Education")
                        .font(.largeTitle.bold())
                        .foregroundColor(.primary)
                    
                    Text("Learn the science and art of color")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.csSandyBeige.opacity(0.3), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // Section Picker
                Picker("Section", selection: $selectedSection) {
                    ForEach(sections.indices, id: \.self) { index in
                        Text(sections[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Content
                ScrollView {
                    Group {
                        switch selectedSection {
                        case 0:
                            ColorTheoryContent()
                        case 1:
                            ColorPsychologyContent()
                        case 2:
                            DesignTipsContent()
                        case 3:
                            AccessibilityContent()
                        default:
                            ColorTheoryContent()
                        }
                    }
                    .padding()
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct ColorTheoryContent: View {
    var body: some View {
        VStack(spacing: 25) {
            EducationalCard(
                title: "Primary Colors",
                description: "The foundation of all color mixing. Red, blue, and yellow cannot be created by mixing other colors.",
                content: {
                    HStack(spacing: 20) {
                        ColorTheoryCircle(color: .red, label: "Red")
                        ColorTheoryCircle(color: .blue, label: "Blue")
                        ColorTheoryCircle(color: .yellow, label: "Yellow")
                    }
                }
            )
            
            EducationalCard(
                title: "Color Wheel Relationships",
                description: "Understanding how colors relate to each other on the color wheel is essential for creating harmonious palettes.",
                content: {
                    VStack(spacing: 15) {
                        ColorRelationshipRow(
                            title: "Complementary",
                            description: "Colors opposite on the wheel",
                            example: (Color.csDeepRed, Color.csVibrantGreen)
                        )
                        
                        ColorRelationshipRow(
                            title: "Analogous",
                            description: "Colors next to each other",
                            example: (Color.csBrightYellow, Color.csNeonYellow)
                        )
                        
                        ColorRelationshipRow(
                            title: "Triadic",
                            description: "Three evenly spaced colors",
                            example: (Color.csDeepRed, Color.csBrightYellow)
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "ColorSync Palette Analysis",
                description: "How our carefully selected colors work together to create visual harmony and professional appeal.",
                content: {
                    VStack(spacing: 15) {
                        PaletteAnalysisRow(
                            colors: [Color.csDeepRed, Color.csSandyBeige, Color.csBrightYellow],
                            title: "Background Harmony",
                            analysis: "Warm tones that create depth and sophistication"
                        )
                        
                        PaletteAnalysisRow(
                            colors: [Color.csVibrantGreen, Color.csNeonYellow, Color.csBoldRed],
                            title: "Element Contrast",
                            analysis: "High contrast for optimal readability and attention"
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "Temperature and Mood",
                description: "Colors can be categorized as warm or cool, each evoking different emotional responses.",
                content: {
                    VStack(spacing: 15) {
                        HStack {
                            VStack {
                                Text("Warm Colors")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Circle().fill(Color.csDeepRed).frame(width: 30, height: 30)
                                    Circle().fill(Color.csBrightYellow).frame(width: 30, height: 30)
                                    Circle().fill(Color.csBoldRed).frame(width: 30, height: 30)
                                }
                                
                                Text("Energy, passion, warmth")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            
                            Spacer()
                            
                            VStack {
                                Text("Neutral/Cool")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                HStack {
                                    Circle().fill(Color.csSandyBeige).frame(width: 30, height: 30)
                                    Circle().fill(Color.csVibrantGreen).frame(width: 30, height: 30)
                                }
                                
                                Text("Balance, nature, calm")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
            )
        }
    }
}

struct ColorPsychologyContent: View {
    var body: some View {
        VStack(spacing: 25) {
            EducationalCard(
                title: "Color Psychology Basics",
                description: "Colors have profound psychological effects on human behavior and emotion. Understanding these effects helps create more impactful designs.",
                content: {
                    VStack(spacing: 12) {
                        Text("Colors can influence:")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            PsychologyPoint(icon: "brain", text: "Cognitive performance")
                            PsychologyPoint(icon: "heart", text: "Emotional state")
                            PsychologyPoint(icon: "eye", text: "Visual attention")
                            PsychologyPoint(icon: "cart", text: "Purchase decisions")
                        }
                    }
                }
            )
            
            ForEach(ColorSyncPalette.allColors, id: \.2) { colorData in
                ColorPsychologyCard(
                    color: colorData.1,
                    name: colorData.0,
                    hex: colorData.2
                )
            }
            
            EducationalCard(
                title: "Cultural Considerations",
                description: "Color meanings can vary significantly across cultures. Consider your audience when choosing colors for global applications.",
                content: {
                    VStack(spacing: 15) {
                        CulturalColorRow(
                            color: Color.csDeepRed,
                            western: "Passion, danger, love",
                            eastern: "Good luck, prosperity, joy"
                        )
                        
                        CulturalColorRow(
                            color: Color.csVibrantGreen,
                            western: "Nature, growth, money",
                            eastern: "Health, harmony, peace"
                        )
                        
                        CulturalColorRow(
                            color: Color.csBrightYellow,
                            western: "Happiness, caution, energy",
                            eastern: "Prosperity, imperial power"
                        )
                    }
                }
            )
        }
    }
}

struct DesignTipsContent: View {
    var body: some View {
        VStack(spacing: 25) {
            EducationalCard(
                title: "60-30-10 Rule",
                description: "A classic interior design rule that works perfectly for digital interfaces and color schemes.",
                content: {
                    VStack(spacing: 15) {
                        DesignRuleExample(
                            percentage: "60%",
                            color: Color.csSandyBeige,
                            description: "Dominant color (backgrounds, large areas)"
                        )
                        
                        DesignRuleExample(
                            percentage: "30%",
                            color: Color.csDeepRed,
                            description: "Secondary color (sections, panels)"
                        )
                        
                        DesignRuleExample(
                            percentage: "10%",
                            color: Color.csVibrantGreen,
                            description: "Accent color (buttons, highlights)"
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "Contrast Guidelines",
                description: "Proper contrast ensures readability and accessibility while maintaining visual hierarchy.",
                content: {
                    VStack(spacing: 15) {
                        ContrastExample(
                            background: Color.csSandyBeige,
                            text: Color.csDeepRed,
                            title: "Good Contrast",
                            description: "Easy to read, comfortable viewing"
                        )
                        
                        ContrastExample(
                            background: Color.csVibrantGreen,
                            text: Color.white,
                            title: "High Contrast",
                            description: "Maximum readability, call-to-action"
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "ColorSync Best Practices",
                description: "Specific recommendations for using our color palette effectively in your projects.",
                content: {
                    VStack(alignment: .leading, spacing: 12) {
                        BestPracticeRow(
                            icon: "checkmark.circle.fill",
                            text: "Use Deep Red for primary branding and important sections",
                            positive: true
                        )
                        
                        BestPracticeRow(
                            icon: "checkmark.circle.fill",
                            text: "Sandy Beige works excellently for large background areas",
                            positive: true
                        )
                        
                        BestPracticeRow(
                            icon: "checkmark.circle.fill",
                            text: "Vibrant Green is perfect for success states and CTAs",
                            positive: true
                        )
                        
                        BestPracticeRow(
                            icon: "xmark.circle.fill",
                            text: "Avoid using Neon Yellow for large text areas",
                            positive: false
                        )
                        
                        BestPracticeRow(
                            icon: "xmark.circle.fill",
                            text: "Don't combine Bold Red with Deep Red without separation",
                            positive: false
                        )
                    }
                }
            )
        }
    }
}

struct AccessibilityContent: View {
    var body: some View {
        VStack(spacing: 25) {
            EducationalCard(
                title: "WCAG Guidelines",
                description: "Web Content Accessibility Guidelines ensure your color choices are inclusive for all users, including those with visual impairments.",
                content: {
                    VStack(spacing: 15) {
                        AccessibilityStandard(
                            level: "AA",
                            ratio: "4.5:1",
                            description: "Minimum contrast for normal text"
                        )
                        
                        AccessibilityStandard(
                            level: "AAA",
                            ratio: "7:1",
                            description: "Enhanced contrast for better accessibility"
                        )
                        
                        AccessibilityStandard(
                            level: "AA Large",
                            ratio: "3:1",
                            description: "Minimum contrast for large text (18pt+)"
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "Color Blindness Considerations",
                description: "Approximately 8% of men and 0.5% of women have some form of color vision deficiency. Design inclusively.",
                content: {
                    VStack(spacing: 15) {
                        ColorBlindnessInfo(
                            type: "Deuteranopia",
                            description: "Difficulty distinguishing reds and greens",
                            percentage: "1% of males"
                        )
                        
                        ColorBlindnessInfo(
                            type: "Protanopia",
                            description: "Reduced sensitivity to red light",
                            percentage: "1% of males"
                        )
                        
                        ColorBlindnessInfo(
                            type: "Tritanopia",
                            description: "Difficulty with blue and yellow",
                            percentage: "0.01% of population"
                        )
                    }
                }
            )
            
            EducationalCard(
                title: "ColorSync Accessibility",
                description: "Our palette has been carefully designed with accessibility in mind. Here's how each color performs:",
                content: {
                    VStack(spacing: 12) {
                        AccessibilityColorRow(
                            color: Color.csDeepRed,
                            name: "Deep Red",
                            rating: "Good",
                            note: "High contrast on light backgrounds"
                        )
                        
                        AccessibilityColorRow(
                            color: Color.csVibrantGreen,
                            name: "Vibrant Green",
                            rating: "Excellent",
                            note: "Strong contrast, colorblind-friendly"
                        )
                        
                        AccessibilityColorRow(
                            color: Color.csSandyBeige,
                            name: "Sandy Beige",
                            rating: "Good",
                            note: "Neutral, works well as background"
                        )
                    }
                }
            )
        }
    }
}

// MARK: - Supporting Views

struct EducationalCard<Content: View>: View {
    let title: String
    let description: String
    let content: () -> Content
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ColorTheoryCircle: View {
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
            
            Text(label)
                .font(.caption.bold())
                .foregroundColor(.primary)
        }
    }
}

struct ColorRelationshipRow: View {
    let title: String
    let description: String
    let example: (Color, Color)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Circle()
                    .fill(example.0)
                    .frame(width: 30, height: 30)
                
                Circle()
                    .fill(example.1)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct PaletteAnalysisRow: View {
    let colors: [Color]
    let title: String
    let analysis: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 5) {
                    ForEach(colors.indices, id: \.self) { index in
                        Circle()
                            .fill(colors[index])
                            .frame(width: 20, height: 20)
                    }
                }
            }
            
            Text(analysis)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct PsychologyPoint: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.csVibrantGreen)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct ColorPsychologyCard: View {
    let color: Color
    let name: String
    let hex: String
    
    var psychologyText: String {
        switch name {
        case "Deep Red":
            return "Evokes passion, urgency, and power. Excellent for CTAs and important alerts. Can increase heart rate and create a sense of energy."
        case "Sandy Beige":
            return "Represents warmth, comfort, and reliability. Creates a calming, professional atmosphere. Associated with stability and trustworthiness."
        case "Bright Yellow":
            return "Stimulates creativity, optimism, and mental clarity. Captures attention quickly but should be used sparingly to avoid overwhelming users."
        case "Vibrant Green":
            return "Symbolizes growth, success, and harmony. Often used for positive actions like 'Go' or 'Success'. Easiest color on the eyes for extended viewing."
        case "Neon Yellow":
            return "High energy and attention-grabbing. Perfect for highlights and warnings. Can cause eye strain if overused, so apply strategically."
        case "Bold Red":
            return "Conveys strength, importance, and urgency. Ideal for errors, warnings, or critical actions. Commands immediate attention and action."
        default:
            return "This color has unique psychological properties that affect user behavior and emotional response."
        }
    }
    
    var body: some View {
        EducationalCard(
            title: name,
            description: psychologyText,
            content: {
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                        )
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(hex)
                            .font(.system(.title3, design: .monospaced))
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("RGB: \(Int(color.rgbComponents.red * 255)), \(Int(color.rgbComponents.green * 255)), \(Int(color.rgbComponents.blue * 255))")
                                .font(.caption.monospaced())
                            
                            Text("HSL: \(Int(color.hslComponents.hue))°, \(Int(color.hslComponents.saturation))%, \(Int(color.hslComponents.lightness))%")
                                .font(.caption.monospaced())
                        }
                        .foregroundColor(.secondary)
                    }
                }
            }
        )
    }
}

struct CulturalColorRow: View {
    let color: Color
    let western: String
    let eastern: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Western:")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                    Text(western)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Eastern:")
                        .font(.caption.bold())
                        .foregroundColor(.primary)
                    Text(eastern)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}

struct DesignRuleExample: View {
    let percentage: String
    let color: Color
    let description: String
    
    var body: some View {
        HStack {
            Text(percentage)
                .font(.title2.bold())
                .foregroundColor(.primary)
                .frame(width: 50)
            
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(height: 30)
                .frame(maxWidth: .infinity)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
        }
    }
}

struct ContrastExample: View {
    let background: Color
    let text: Color
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(background)
                .frame(height: 60)
                .overlay(
                    Text("Sample Text")
                        .font(.headline)
                        .foregroundColor(text)
                )
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct BestPracticeRow: View {
    let icon: String
    let text: String
    let positive: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(positive ? Color.csVibrantGreen : Color.csBoldRed)
                .frame(width: 20)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct AccessibilityStandard: View {
    let level: String
    let ratio: String
    let description: String
    
    var body: some View {
        HStack {
            VStack {
                Text(level)
                    .font(.headline.bold())
                    .foregroundColor(.primary)
                
                Text(ratio)
                    .font(.caption.monospaced())
                    .foregroundColor(.secondary)
            }
            .frame(width: 60)
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct ColorBlindnessInfo: View {
    let type: String
    let description: String
    let percentage: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(type)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(percentage)
                .font(.caption.bold())
                .foregroundColor(.primary)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
        }
    }
}

struct AccessibilityColorRow: View {
    let color: Color
    let name: String
    let rating: String
    let note: String
    
    var ratingColor: Color {
        switch rating {
        case "Excellent": return Color.csVibrantGreen
        case "Good": return Color.csBrightYellow
        case "Fair": return Color.csNeonYellow
        default: return Color.csBoldRed
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(note)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(rating)
                .font(.caption.bold())
                .foregroundColor(ratingColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(ratingColor.opacity(0.2))
                )
        }
    }
}

#Preview {
    EducationalView()
} 