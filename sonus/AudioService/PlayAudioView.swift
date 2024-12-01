//
//  PlayAudioView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct PlayAudioView: View {
    @EnvironmentObject var audioService: AudioService
    @EnvironmentObject var fileService: FileService
    @Binding var isImporting: Bool
    
    @FocusState var focus: Bool
    @State var showDropdown: Bool = true
    
    @State var selectedIndex: Int = 0
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    var allFileNames: [String] { fileService.fileNames.keys.sorted() }
    var filteredFileNames: [String] {
        if text.isEmpty { return allFileNames }
        return allFileNames.filter({$0.hasPrefix(text)})
    }
    
    @State var text = ""
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                TextField("Enter text", text: $text)
                    .focused($focus)
                    .font(.largeTitle)
                    .textFieldStyle(.plain)
                    .onChange(of: text) { oldValue, newValue in
                        selectedIndex = 0
                        fileService.readFileNames()
                    }
                    .padding()
                
                Divider()
                
                
                ScrollView {
                    ScrollViewReader { proxy in
                        VStack(spacing: 0) {
                            ForEach(filteredFileNames, id: \.self) { name in
                                Text(name)
                                    .padding()
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundStyle(selectedIndex < filteredFileNames.count ? name == filteredFileNames[selectedIndex] ? Color.accentColor : .primary : .primary)
                                    .background(content: {
                                        if selectedIndex < filteredFileNames.count {
                                            if name == filteredFileNames[selectedIndex] {
                                                Color.accentColor.opacity(0.2)
                                            }
                                        }
                                    })
                                    .id(name)
                                
                                
                                Divider()
                            }
                            .onAppear {
                                scrollProxy = proxy
                            }
                        }
                    }
                }
                .containerRelativeFrame([.vertical], { size, _ in
                    size / 2
                })
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .scrollIndicators(.never)
                .onChange(of: selectedIndex) { old, new in
                    withAnimation {
                        scrollProxy?.scrollTo(filteredFileNames[new], anchor: .bottom)
                    }
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "heart.fill")
                    Spacer()
                    LoadFileButton(isImporting: $isImporting)
                        .frame(width: 30, height: 30)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
            }
            .frame(minWidth: 700)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThickMaterial)
            }
            
            
            
            
            Button {
                fileService.readFileNames()
                if filteredFileNames.isEmpty { return }
                audioService.playAudio(from: fileService.fileNames["\(filteredFileNames[selectedIndex])"]!)
            } label: {
                Image(systemName: "play.circle.fill")
            }
            .keyboardShortcut(.defaultAction)
            .hidden()
            
            Button {
                withAnimation(.smooth(duration: 0.1)) {
                    if selectedIndex - 1 < 0 {
                        selectedIndex = filteredFileNames.count - 1
                    } else {
                        selectedIndex -= 1
                    }
                }
            } label: {
                Image(systemName: "arrow.up")
            }
            .keyboardShortcut(.upArrow, modifiers: .capsLock)
            .hidden()
            
            Button {
                withAnimation(.smooth(duration: 0.1)) {
                    if selectedIndex + 1 >= filteredFileNames.count {
                        selectedIndex = 0
                    } else {
                        selectedIndex += 1
                    }
                }
            } label: {
                Image(systemName: "arrow.down")
            }
            .keyboardShortcut(.downArrow, modifiers: .capsLock)
            .hidden()
            
            Spacer()
            
        }
        .toolbar(content: {
            ToolbarItem {
                LoadFileButton(isImporting: $isImporting)
            }
        })
        .padding(.top, 100)
        .padding(.horizontal, 100)
        .frame(maxHeight: .infinity)
        .onAppear {
            focus = true
            fileService.readFileNames()
        }
        .onDrop(of: [.audio], isTargeted: $isImporting, perform: { providers in
            for provider in providers {
                
                if provider.hasItemConformingToTypeIdentifier(UTType.audio.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.audio.identifier, completionHandler: { data, error in
                        if let error {
                            print("error loading item")
                            print(error)
                            return
                        }
                        if let fileURL = data as? URL {
                            let _ = fileURL.startAccessingSecurityScopedResource()
                            fileService.saveFiles(from: [fileURL])
                            fileURL.stopAccessingSecurityScopedResource()
                            return
                        }
                    })
                }
            }
            return true
        })
    }
}

#Preview {
    PlayAudioView(isImporting: .constant(true))
}
