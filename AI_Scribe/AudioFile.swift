//
//  AudioFile.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI
import Speech

class AudioFile: Identifiable, Codable {
    let id: UUID
    let relativeURL: URL
    let length: TimeInterval
    let date: Date
    
    @Published var lastLiveTranscription: String?
    @Published var processedData: [String: String] = [:]
    @Published var isProcessed: Bool = false
    
    enum CodingKeys: CodingKey {
        case id, url, length, date, lastLiveTranscription, processedData, isProcessed

    }
    
    init(id: UUID, url: URL, length: TimeInterval, date: Date) {
        self.id = id
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.relativeURL = URL(string: url.absoluteString.replacingOccurrences(of: documentsURL.absoluteString, with: ""))!
        self.length = length
        self.date = date
    }
    
    func set_lastLiveTranscript(lastLiveTranscription: String = "") {
        self.lastLiveTranscription = lastLiveTranscription
        self.processedData["lastLiveTranscription"] = lastLiveTranscription
        
        RecordingsManager.shared.updateRecording(self)
    }
    
    
    func process() {
        let recognizer = SFSpeechRecognizer()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let absoluteURL = documentsURL.appendingPathComponent(self.relativeURL.path)
        let request = SFSpeechURLRecognitionRequest(url: absoluteURL)
        
        recognizer?.recognitionTask(with: request) { [weak self] (result, error) in
            guard let result = result else {
                print("There was an error: \(error!)")
                return
            }
            
            guard let strongSelf = self else {
                return
            }
            
            if result.isFinal {
                DispatchQueue.main.async {
                    self?.processedData["finalTranscription"] = result.bestTranscription.formattedString
                    self?.isProcessed = true
                    RecordingsManager.shared.updateRecording(strongSelf)
                }
            }
        }
        
        
 
    }
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        relativeURL = try container.decode(URL.self, forKey: .url)
        length = try container.decode(TimeInterval.self, forKey: .length)
        date = try container.decode(Date.self, forKey: .date)
        lastLiveTranscription = try container.decodeIfPresent(String.self, forKey: .lastLiveTranscription)
        processedData = try container.decodeIfPresent([String: String].self, forKey: .processedData) ?? [:]
        isProcessed = try container.decodeIfPresent(Bool.self, forKey: .isProcessed) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(relativeURL, forKey: .url)
        try container.encode(length, forKey: .length)
        try container.encode(date, forKey: .date)
        try container.encode(lastLiveTranscription, forKey: .lastLiveTranscription)
        try container.encode(processedData, forKey: .processedData)
        try container.encode(isProcessed, forKey: .isProcessed)
    }
}

