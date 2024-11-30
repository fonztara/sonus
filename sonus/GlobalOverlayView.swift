//
//  GlobalOverlayView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 29/11/24.
//

import SwiftUI

struct GlobalOverlayView: View {
    @State private var isOverlayVisible = true
    @State private var inputText = ""

    var body: some View {
        ZStack {
            ContentView()

            if isOverlayVisible {
                VStack {
                    TextField("Type something...", text: $inputText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .frame(maxWidth: 400)

                    Button("Close") {
                        isOverlayVisible = false
                    }
                    .padding(.top)
                }
                .frame(width: 500, height: 200)
                .background(Color(.windowBackgroundColor))
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
        .onAppear {
            setupGlobalHotkey()
        }
    }

    func setupGlobalHotkey() {
        let hotkeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { event in
            // Use Command + Shift + O as the hotkey
            if event.modifierFlags.contains(.command) && event.modifierFlags.contains(.shift) && event.charactersIgnoringModifiers == "o" {
                isOverlayVisible = true
            }
        }
        // Ensure hotkeyMonitor stays active
        _ = hotkeyMonitor
    }
}

struct GlobalOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalOverlayView()
    }
}
