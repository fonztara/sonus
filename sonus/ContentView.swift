//
//  ContentView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 28/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var isImporting: Bool = false
    
    var body: some View {
        PlayAudioView(isImporting: $isImporting)
            .background {
                ZStack {
                    Image("bg")
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
            }
    }
}

#Preview {
    ContentView()
}
