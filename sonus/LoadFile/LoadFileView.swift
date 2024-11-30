//
//  LoadFileView.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import SwiftUI

struct LoadFileView: View {
    @EnvironmentObject var fileService: FileService
    @EnvironmentObject var audioService: AudioService
    
    @State var file: URL? = nil
    @State var importFile: Bool = false
    
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
        .fileImporter(isPresented: $importFile, allowedContentTypes: [.mp3, .wav], onCompletion: { result in
            if case .success(let url) = result {
                fileService.saveFile(from: url)
            }
        })
    }
}

#Preview {
    LoadFileView()
}
