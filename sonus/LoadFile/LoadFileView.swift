//
//  LoadFileView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct LoadFileView: View {
    @EnvironmentObject var fileService: FileService
    @EnvironmentObject var audioService: AudioService
    
    @State var file: URL? = nil
    @State var importFile: Bool = false
    @State var isImporting: Bool = false
    
    var allFileNames: [String] { fileService.fileNames.keys.sorted() }
    
    var body: some View {
        VStack {
            Button {
                self.importFile = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.background)
                    Image(systemName: "arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    if isImporting {
                        RoundedRectangle(cornerRadius: 8)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color.accentColor.opacity(0.2))
                    }
                }
            }
            .padding()
            .buttonStyle(.plain)
            
            ScrollView {
                ForEach(allFileNames, id: \.self) { name in
                    HStack {
                        Text(name)
                        
                        Text("\(String(describing: fileService.fileNames[name]))")
                    }
                }
            }
        }
        .onAppear {
            fileService.readFileNames()
        }
        .onDrop(of: [.audio], isTargeted: $isImporting, perform: { providers in
            guard let provider = providers.first else {
                return false
            }
            
            if provider.hasItemConformingToTypeIdentifier(UTType.audio.identifier) {
                provider.loadItem(forTypeIdentifier: UTType.audio.identifier, completionHandler: { data, error in
                    if let error {
                        print("error loading item")
                        print(error)
                        return
                    }
                    if let fileURL = data as? URL {
                        let _ = fileURL.startAccessingSecurityScopedResource()
                        fileService.saveFile(from: fileURL)
                        fileURL.stopAccessingSecurityScopedResource()
                        return
                    }
                })
            }
            return true
        })
        .fileImporter(isPresented: $importFile, allowedContentTypes: [.audio], onCompletion: { result in
            if case .success(let url) = result {
                fileService.saveFile(from: url)
            }
        })
    }
}

#Preview {
    LoadFileView()
}
