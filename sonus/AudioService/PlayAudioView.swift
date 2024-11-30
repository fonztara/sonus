//
//  PlayAudioView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import SwiftUI

struct PlayAudioView: View {
    @EnvironmentObject var audioService: AudioService
    @EnvironmentObject var fileService: FileService
    
    @FocusState var focus: Bool
    @State var showDropdown: Bool = true
    
    @State var selectedIndex: Int = 0
    
    var allFileNames: [String] { fileService.fileNames.keys.sorted() }
    var filteredFileNames: [String] {
        if text.isEmpty { return allFileNames }
        return allFileNames.filter({$0.hasPrefix(text)})
    }
    
    @State var text = ""
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $text)
                .padding(.top, 150)
                .focused($focus)
                .textFieldStyle(.roundedBorder)
            
            if showDropdown && !filteredFileNames.isEmpty {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredFileNames, id: \.self) { name in
                            Text(name)
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(name == filteredFileNames[selectedIndex] ? .blue : .primary)
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 100)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            
            Button {
                if filteredFileNames.isEmpty { return }
                audioService.playAudio(from: fileService.fileNames["\(filteredFileNames[selectedIndex])"]!)
            } label: {
                Image(systemName: "play.circle.fill")
            }
            .keyboardShortcut(.defaultAction)
            .hidden()
            
            Button {
                if selectedIndex - 1 < 0 {
                    selectedIndex = filteredFileNames.count - 1
                } else {
                    selectedIndex -= 1
                }
            } label: {
                Image(systemName: "arrow.up")
            }
            .keyboardShortcut(.upArrow)
            //            .hidden()
            
            Button {
                if selectedIndex + 1 >= filteredFileNames.count {
                    selectedIndex = 0
                } else {
                    selectedIndex += 1
                }
            } label: {
                Image(systemName: "arrow.down")
            }
            .keyboardShortcut(.downArrow)
            //            .hidden()
            
            Spacer()
        }
        .frame(width: 400)
        .frame(maxHeight: .infinity)
        .onAppear {
            focus = true
        }
    }
}

#Preview {
    PlayAudioView()
}
