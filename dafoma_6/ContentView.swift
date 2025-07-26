//
//  ContentView.swift
//  dafoma_6
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("preferredBackground") private var preferredBackground = "#ae2d27"
    
    var body: some View {
        TabView {
            ColorShowcaseView()
                .tabItem {
                    Image(systemName: "paintpalette")
                    Text("Showcase")
                }
            
            ColorMixerView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Mixer")
                }
            
            DeveloperToolsView()
                .tabItem {
                    Image(systemName: "hammer")
                    Text("Dev Tools")
                }
            
            EducationalView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Learn")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
        .accentColor(Color.csVibrantGreen)
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
