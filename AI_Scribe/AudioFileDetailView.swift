//
//  AudioFileDetailView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import AVFoundation
import SwiftUI

struct AudioFileDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var audioFile: AudioFile
    var recordingsManager: RecordingsManager
    var deletedCallback: () -> ()
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var currentTime: TimeInterval = 0
    
    @State private var question: String = ""
    @State private var answer: Substring?
    
    @State private var selectedKey: String = "lastLiveTranscription"
    @State private var selectedString: String = ""
    
    init(audioFile: AudioFile, recordingsManager: RecordingsManager, deletedCallback: @escaping () -> ()) {
        self.audioFile = audioFile
        self.recordingsManager = recordingsManager
        self.deletedCallback = deletedCallback
    }
    
    var body: some View {
        
        VStack {
            
            Text("Date: \(formatDate(audioFile.date))")
            
            Picker(selection: $selectedKey, label: Text("Processed Data")) {
                ForEach(Array(audioFile.processedData.keys), id: \.self) { key in
                    Text(key).tag(key)
                }
            }
            .onChange(of: selectedKey) { newValue in
                selectedString = audioFile.processedData[newValue] ?? ""
            }

            
            
            ZStack {
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.primary, lineWidth: 3)
                    .frame(width: 300, height: 300)
                    
                ScrollView {
                    Text(selectedString)
                        .textSelection(.enabled)
                        //.padding()
                }
                .frame(maxWidth: 270, maxHeight: 270)
                
            }
            
            Spacer()
            
            
            Text("Current Time: \(formattedTime(currentTime))")
            Text("Total Time: \(formattedTime(audioFile.length))")
            
            Slider(value: $currentTime, in: 0...audioFile.length, onEditingChanged: sliderChanged)
                .padding()
            
            Button(action: {
                if isPlaying {
                    audioPlayer?.pause()
                } else {
                    startPlaying()
                }
                isPlaying.toggle()
            }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            /*
            Button(action: {
                recordingsManager.deleteRecording(audioFile)
                deletedCallback()
                presentationMode.wrappedValue.dismiss() // dismiss this view
            }) {
                Text("Delete Recording")
                    .foregroundColor(.red)
            }
             */
            
        }
        .onAppear(perform: {
            preparePlayer()
            selectedString = audioFile.processedData["lastLiveTranscription"] ?? "No lastLiveTranscript."
        })
        .onDisappear(perform: stopPlayer)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    recordingsManager.deleteRecording(audioFile)
                    //deletedCallback()
                    presentationMode.wrappedValue.dismiss() // dismiss this view
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func preparePlayer() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let absoluteURL = documentsURL.appendingPathComponent(audioFile.relativeURL.path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: absoluteURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Failed to load audio file: \(error)")
        }
    }
    
    func startPlaying() {
        audioPlayer?.play()
        startTimer()
    }
    
    func stopPlayer() {
        audioPlayer?.stop()
        stopTimer()
    }
    
    func sliderChanged(editingStarted: Bool) {
        if editingStarted {
            audioPlayer?.pause()
            stopTimer()
        } else {
            if let currentTime = audioPlayer?.currentTime {
                self.currentTime = currentTime
            }
            audioPlayer?.play()
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            guard let audioPlayer = audioPlayer else {
                timer.invalidate()
                return
            }
            
            if audioPlayer.isPlaying {
                currentTime = audioPlayer.currentTime
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func stopTimer() {
        currentTime = 0
        isPlaying = false
    }
    
    
}

