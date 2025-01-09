//
//  ContentView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var fileService: FileService = FileService()
    @StateObject var audioService: AudioService = AudioService()
    @StateObject var settings: AppSettings = AppSettings()
    @State var isImporting: Bool = false
    
    var body: some View {
        ZStack {
            WindowView(isImporting: $isImporting)
                .environmentObject(fileService)
                .environmentObject(audioService)
                .environmentObject(settings)
            if settings.isInSettings {
                SettingsView()
                    .environmentObject(settings)
            }
        }
    }
}

#Preview {
    ContentView()
}
