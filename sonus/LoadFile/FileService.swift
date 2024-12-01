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
    }
    
    func saveFiles(from urls: [URL]) {
        for url in urls {
            let fileName = url.lastPathComponent
            let filePath = self.folderPath.appendingPathComponent(fileName)
            if url.startAccessingSecurityScopedResource() {
                do {
                    try Data(contentsOf: url).write(to: filePath)
                    self.readFileNames()
                } catch {
                    print("Error saving file: \(error)")
                }
                url.stopAccessingSecurityScopedResource()
            } else {
                do {
                    try Data(contentsOf: url).write(to: filePath)
                    self.readFileNames()
                } catch {
                    print("Error saving file: \(error)")
                }
                print("Permission failed")
            }
        }
    }
    
    func readFileNames() {
        DispatchQueue.main.async {
            self.fileNames.removeAll()
        }
        do {
            let Path = folderPath.absoluteURL
            let directoryContents = try FileManager.default.contentsOfDirectory(at: Path, includingPropertiesForKeys: nil, options: [])
            for url in directoryContents {
                let fileName = url.lastPathComponent
                if fileName.contains(".") && fileName.first != "." {
                    if let nameOnly = fileName.split(separator: ".").first {
                        DispatchQueue.main.async {
                            self.fileNames[nameOnly.lowercased()] = url
                        }
                    }
                }
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteFile(_ fileName: String) {
        do {
            try FileManager.default.removeItem(at: fileNames[fileName]!)
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.readFileNames()
    }
    
    func changeFileName(_ fileName: String, to newName: String) {
        let fileFormat = fileNames[fileName]!.lastPathComponent.split(separator: ".").last!
        do {
            try FileManager.default.moveItem(at: fileNames[fileName]!, to: folderPath.appendingPathComponent(newName + "." + fileFormat))
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.readFileNames()
    }
}
