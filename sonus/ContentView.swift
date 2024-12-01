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
    @State var isImporting: Bool = false
    
    var body: some View {
        PlayAudioView(isImporting: $isImporting)
            .environmentObject(fileService)
            .environmentObject(audioService)
    }
}

#Preview {
    ContentView()
}
