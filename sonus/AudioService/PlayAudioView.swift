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
    
    @FocusState var textFieldFocus: Bool
    @FocusState var nameEditFocus: Bool
    @State var showDropdown: Bool = true
    
    @State var isDeleting: Bool = false
    @State var nameToEdit: String = ""
    @State var nameEditing: String = ""
    @State var nameToDelete: String = ""
    
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
                    .focused($textFieldFocus)
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
                                HStack {
                                    if nameToEdit == name {
                                        TextField("Enter new name", text: $nameEditing)
                                            .textFieldStyle(.plain)
                                            .focused($nameEditFocus)
                                            .onSubmit {
                                                fileService.changeFileName(name, to: nameEditing)
                                                nameToEdit = ""
                                                nameEditing = ""
                                                textFieldFocus = true
                                            }
                                    } else {
                                        Text(name)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        nameToEdit = name
                                        nameEditing = name
                                        nameEditFocus = true
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Button {
                                        isDeleting = true
                                        nameToDelete = name
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                    .foregroundStyle(.red)
                                    .buttonStyle(.plain)
                                }
                                .alert("Delete \(nameToDelete)?", isPresented: $isDeleting, actions: {
                                    Button("Delete", role: .destructive) {
                                        fileService.deleteFile(nameToDelete)
                                        isDeleting = false
                                    }
                                    Button("Cancel", role: .cancel) {
                                        nameToDelete = ""
                                        isDeleting = false
                                    }
                                }, message: {
                                    Text("You can't undo this action")
                                })
                                .padding()
                                .font(.title3)
                                .onHover(perform: { hover in
                                    withAnimation(.smooth(duration: 0.3)) {
                                        if let index = filteredFileNames.firstIndex(of: name) {
                                            selectedIndex = index
                                        }
                                    }
                                })
                                .background(content: {
                                    if selectedIndex >= 0 && selectedIndex < filteredFileNames.count {
                                        if name == filteredFileNames[selectedIndex] {
                                            Color.accentColor.opacity(0.2)
                                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                                .padding(4)
                                        }
                                    }
                                })
                                .id(name)
                                
                            }
                            .onAppear {
                                scrollProxy = proxy
                            }
                        }
                    }
                }
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                .scrollIndicators(.never)
                .onChange(of: selectedIndex) { old, new in
                    withAnimation(.smooth(duration: 0.3)) {
                        if new >= 0 && new < filteredFileNames.count {
                            scrollProxy?.scrollTo(filteredFileNames[new])
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    Image(systemName: "heart.fill")
                    
                    Spacer()
                    
                    RecordAudioButton()
                        .frame(width: 30, height: 30)
                    
                    LoadFileButton(isImporting: $isImporting)
                        .frame(width: 30, height: 30)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                Divider()
            }
            .frame(minWidth: 700, minHeight: 400)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThickMaterial)
            }
            
            HStack {
                Button {
                    fileService.readFileNames()
                    if filteredFileNames.isEmpty { return }
                    audioService.playAudio(from: fileService.fileNames["\(filteredFileNames[selectedIndex])"]!)
                } label: {
                    Image(systemName: "play.circle.fill")
                }
                .keyboardShortcut(.defaultAction)
                
                Button {
                    withAnimation(.smooth(duration: 0.3)) {
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
                
                Button {
                    withAnimation(.smooth(duration: 0.3)) {
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
            }
            .frame(width: 0, height: 0)
            .hidden()
            
        }
        .onAppear {
            textFieldFocus = true
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
