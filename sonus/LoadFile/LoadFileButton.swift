//
//  LoadFileView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct LoadFileButton: View {
    @EnvironmentObject var fileService: FileService
    @EnvironmentObject var audioService: AudioService
    
    @State var file: URL? = nil
    @State var importFile: Bool = false
    @Binding var isImporting: Bool
    
    var allFileNames: [String] { fileService.fileNames.keys.sorted() }
    
    var body: some View {
        Button {
            self.importFile = true
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(.background)
                if isImporting {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.accentColor.opacity(0.2))
                }
                Image(systemName: "arrow.down")
                    .resizable()
                    .scaledToFit()
                    .padding(8)
            }
        }
        .buttonStyle(.plain)
        .onAppear {
            fileService.readFileNames()
        }
        .fileImporter(isPresented: $importFile, allowedContentTypes: [.audio], allowsMultipleSelection: true, onCompletion: { result in
            if case .success(let urls) = result {
                fileService.saveFiles(from: urls)
            }
        })
    }
}

#Preview {
    LoadFileButton(isImporting: .constant(true))
}
