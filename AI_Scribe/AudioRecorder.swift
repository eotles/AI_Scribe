//
//  AudioRecorder.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI
import AVFoundation
import Speech

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    var audioFileName: URL?
    var recordingsManager: RecordingsManager
    
    @Published var recording = false
    @Published var paused = false
    @Published var complete = false
    @Published var audioLength: TimeInterval = 0.0
    @Published var timer: Timer?
    
    private let engine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_US"))!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var liveTranscript = ""
    
    init(recordingsManager: RecordingsManager) {
        self.recordingsManager = recordingsManager
    }
    
    func startRecording() {
        let recordingSession = AVAudioSession.sharedInstance()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            audioFileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(UUID().uuidString + ".wav")
            guard let audioFileName = audioFileName else { return }
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recording = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.audioLength += 1.0
            }
            
            // Prepare and start the speech recognition.
            prepareSpeechRecognition()
            engine.prepare()
            try? engine.start()
            
        } catch {
            print("Failed to set up recording session: \(error)")
        }
    }
    
    func pauseRecording() {
        audioRecorder.pause()
        paused = true
        timer?.invalidate()
    }
    
    func resumeRecording() {
        audioRecorder.record()
        paused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.audioLength += 1.0
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        timer?.invalidate()
        
        // Stop the speech recognition.
        engine.stop()
        request?.endAudio()
        recognitionTask?.cancel()
        request = nil
        recognitionTask = nil
        
        if let url = audioFileName {
            let audioFile = AudioFile(id: UUID(), url: url, length: audioLength, date: Date())
            recordingsManager.saveRecording(audioFile)
            audioFile.set_lastLiveTranscript(lastLiveTranscription: liveTranscript)
            audioFile.process()
            //recordingsManager.updateRecording(audioFile)
        }
        
        complete = true
    }
    
    private func prepareSpeechRecognition() {
        request = SFSpeechAudioBufferRecognitionRequest()
        
        let node = engine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request?.append(buffer)
        }
        
        recognitionTask = speechRecognizer.recognitionTask(with: request!) { result, error in
            guard error == nil else {
                print("Speech recognition error: \(error!.localizedDescription)")
                return
            }
            
            guard let result = result else { return }
            
            DispatchQueue.main.async {
                self.liveTranscript = result.bestTranscription.formattedString
            }
        }
    }
}
