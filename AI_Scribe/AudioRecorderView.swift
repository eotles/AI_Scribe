//
//  AudioRecorderView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

struct AudioRecorderView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var audioRecorder: AudioRecorder
    var doneRecording: () -> Void
    
    var body: some View {
        VStack{
            
            Spacer()
            
            AudioRecordLiveTranscriptView(audioRecorder: audioRecorder)
            
            Spacer()
            
            Image(systemName: "waveform")
            
            Spacer()
            
            HStack {
                
                Spacer()
                
                Text("\(formattedTime)")
                
                
                Spacer()
                
                Button(action: {
                    print("Recording: \(audioRecorder.recording), Paused: \(audioRecorder.paused)")
                    
                    if audioRecorder.recording && !audioRecorder.paused {
                        print("Button - Pause")
                        audioRecorder.pauseRecording()
                        
                    } else if audioRecorder.paused {
                        print("Button - Resume")
                        audioRecorder.resumeRecording()
                        
                    } else {
                        print("Button - Start")
                        audioRecorder.startRecording()
                        
                    }
                    
                    print("Recording: \(audioRecorder.recording), Paused: \(audioRecorder.paused)")
                }) {
                    if audioRecorder.recording && !audioRecorder.paused {
                        AudioRecordPauseButton()
                    } else if audioRecorder.paused {
                        AudioRecordResumeButton()
                    } else {
                        AudioRecordStartButton()
                    }
                }
                //.disabled(audioRecorder.audioFileName != nil)
                .disabled(audioRecorder.complete)
                
                Spacer()
                
                Button(action: {
                    audioRecorder.stopRecording()
                    doneRecording()
                    print("Recording: \(audioRecorder.recording), Paused: \(audioRecorder.paused)")
                    dismiss()
                }) {
                    Text("Done")
                }
                .disabled(!audioRecorder.recording)
                
                Spacer()
                
            }
            Spacer()
            
        }
        .interactiveDismissDisabled()
    }
    
    var formattedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: audioRecorder.audioLength) ?? "0:00"
    }
}

struct AudioRecorderView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecorderView(
            audioRecorder: AudioRecorder(
                recordingsManager: RecordingsManager.shared
            ),
            doneRecording: {}
        )
    }
}

