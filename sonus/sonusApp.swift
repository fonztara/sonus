//
//  sonusApp.swift
//  sonus
//
//  Created by Alfonso Tarallo on 28/11/24.
//

import SwiftUI

@main
struct sonusApp: App {
    @StateObject var fileService: FileService = FileService()
    @StateObject var audioService: AudioService = AudioService()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(fileService)
                .environmentObject(audioService)
        }
    }
}
