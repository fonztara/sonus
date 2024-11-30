//
//  FileService.swift
//  sonus
//
//  Created by Alfonso Tarallo on 30/11/24.
//

import Foundation

class FileService: ObservableObject {
    let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    @Published var fileNames: [String: URL] = [:]
    
    init() {
        readFileNames()
        print(fileNames)
    }
    
    func saveFile(from url: URL) {
        let fileName = url.lastPathComponent
        let filePath = self.folderPath.appendingPathComponent(fileName)
        
        if url.startAccessingSecurityScopedResource() {
            do {
                try Data(contentsOf: url).write(to: filePath)
                fileNames[fileName.split(separator: ".").first!.lowercased()] = filePath
                print(fileNames)
            } catch {
                print("Error saving file: \(error)")
            }
            url.stopAccessingSecurityScopedResource()
        } else {
            print("Permission failed")
        }
    }
    
    private func readFileNames() {
        do {
            let Path = folderPath.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
            for url in directoryContents {
                let fileName = url.lastPathComponent
                if fileName.hasSuffix(".mp3") || fileName.hasSuffix(".wav") {
                    fileNames[fileName.split(separator: ".").first!.lowercased()] = url
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
