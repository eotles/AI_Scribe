//
//  RecordingsManager.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

class RecordingsManager: ObservableObject {
    @Published var recordings: [AudioFile] = []
    
    private let userDefaultsKey = "Recordings"
    static let shared = RecordingsManager() // The shared singleton instance
    
    private init() {
        loadRecordings()
    }
    
    func saveRecording(_ recording: AudioFile) {
        recordings.append(recording)
        saveToUserDefaults()
    }
    
    func deleteRecording(_ recording: AudioFile) {
        if let index = recordings.firstIndex(where: { $0.id == recording.id }) {
            do {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let absoluteURL = documentsURL.appendingPathComponent(recording.relativeURL.path)
                
                try FileManager.default.removeItem(at: absoluteURL)
                
                recordings.remove(at: index)
                saveToUserDefaults()
            } catch {
                print("Failed to delete recording: \(error)")
            }
        }
    }
    
    func updateRecording(_ updatedRecording: AudioFile) {
        if let index = recordings.firstIndex(where: { $0.id == updatedRecording.id }) {
            recordings[index] = updatedRecording
            saveToUserDefaults()
        }
    }
    
    
    private func loadRecordings() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedRecordings = try? JSONDecoder().decode([AudioFile].self, from: data) {
            self.recordings = savedRecordings
        }
    }
    
    private func saveToUserDefaults() {
        if let data = try? JSONEncoder().encode(recordings) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}

