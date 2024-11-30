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
    var body: some View {
        NavigationSplitView {
            VStack {
                ForEach(ViewName.allCases, id: \.self) { viewName in
                    Button(viewName.rawValue) {
                        selectedView = viewName
                    }
                }
            }
        } detail: {
            switch selectedView {
            case .loadFile: LoadFileView()
            case .playAudio: PlayAudioView()
            }
        }
    }
}

#Preview {
    ContentView()
}
