//
//  RecordAudioButton.swift
//  sonus
//
//  Created by Alfonso Tarallo on 01/12/24.
//

import SwiftUI

struct RecordAudioButton: View {
    @EnvironmentObject var fileService: FileService
    @EnvironmentObject var audioService: AudioService
    
    @State var isRecording: Bool = false
    
    var allFileNames: [String] { fileService.fileNames.keys.sorted() }
    
    var body: some View {
        Button {
            if !isRecording && audioService.checkMicrophonePermission() {
                isRecording = true
                if audioService.recorder != nil {
                    audioService.recorder?.record()
                }
            } else {
                isRecording = false
                if audioService.recorder != nil {
                    audioService.recorder?.stop()
                    audioService.recorder = nil
                }
                fileService.readFileNames()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.background)
                if isRecording {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.red.opacity(0.5))
                }
                Image(systemName: isRecording ? "stop.circle.fill" : "mic.fill")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecordAudioButton()
}
