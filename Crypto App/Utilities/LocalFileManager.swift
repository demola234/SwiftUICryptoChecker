//
//  LocalFileManager.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 15/07/2024.
//

import Foundation
import SwiftUI

class LocalFileManagers {
    static let instance = LocalFileManagers()
    
    private init() {}
    
    /// Save an image to a specified folder
    /// - Parameters:
    ///   - image: The UIImage to be saved
    ///   - imageName: The name of the image file
    ///   - folderName: The name of the folder where the image will be saved
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        createFolderIfNeeded(folderName: folderName)
        guard
            let data = image.pngData(),
            let url = getUrlForImage(imageName: imageName, folderName: folderName)
        else {
            print("Error getting URL for image")
            return
        }
        
        do {
            try data.write(to: url)
            print("Image saved successfully: \(imageName) at \(url)")
        } catch {
            print("Error saving image: \(imageName). \(error)")
        }
    }
    
    /// Retrieve an image from a specified folder
    /// - Parameters:
    ///   - imageName: The name of the image file
    ///   - folderName: The name of the folder where the image is stored
    /// - Returns: The UIImage if it exists, otherwise nil
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getUrlForImage(imageName: imageName, folderName: folderName) else {
            print("Error getting URL for image")
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }
    
    /// Create a folder if it does not already exist
    /// - Parameter folderName: The name of the folder to be created
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getUrlForFolder(name: folderName) else {
            print("Error getting URL for folder")
            return
        }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                print("Directory created: \(url)")
            } catch {
                print("Error creating directory: \(folderName). \(error)")
            }
        }
    }
    
    /// Get the URL for a folder in the cache directory
    /// - Parameter name: The name of the folder
    /// - Returns: The URL for the folder if it exists, otherwise nil
    private func getUrlForFolder(name: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        return url.appendingPathComponent(name)
    }
    
    /// Get the URL for an image file in a specified folder
    /// - Parameters:
    ///   - imageName: The name of the image file
    ///   - folderName: The name of the folder where the image is stored
    /// - Returns: The URL for the image file if it exists, otherwise nil
    private func getUrlForImage(imageName: String, folderName: String) -> URL? {
        guard let folderUrl = getUrlForFolder(name: folderName) else { return nil }
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
}
