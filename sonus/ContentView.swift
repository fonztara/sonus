//
//  ContentView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 28/11/24.
//

import SwiftUI

enum ViewName: String, CaseIterable {
    case loadFile, playAudio
}

struct ContentView: View {
    @State var selectedView: ViewName = .playAudio
    @State var isImporting: Bool = false
    
    var body: some View {
        switch selectedView {
        case .loadFile: LoadFileButton(isImporting: $isImporting)
        case .playAudio: PlayAudioView(isImporting: $isImporting)
        }
    }
}

#Preview {
    ContentView()
}
