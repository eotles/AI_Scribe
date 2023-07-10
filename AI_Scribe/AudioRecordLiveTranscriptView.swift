//
//  AudioRecordLiveTranscriptView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI


struct AudioRecordLiveTranscriptView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 20)
                .stroke(.primary, lineWidth: 3)
                .frame(width: 300, height: 300)
                
            
            Text(audioRecorder.liveTranscript)
                .frame(maxWidth: 270, maxHeight: 270)
                .padding()
            
        }
        .padding()
        
    }
}

struct AudioRecordLiveTranscriptView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordLiveTranscriptView(
            audioRecorder: AudioRecorder(
                recordingsManager: RecordingsManager.shared
            )
        )
    }
}

