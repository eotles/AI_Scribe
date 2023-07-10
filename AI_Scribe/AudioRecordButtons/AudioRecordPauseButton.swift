//
//  AudioRecordPauseButton.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

struct AudioRecordPauseButton: View {
    
    var body: some View {
        Image(systemName: "pause.fill")
            .foregroundColor(.red)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
            .overlay(Capsule().stroke(.red, lineWidth: 3))
    }
}

struct AudioRecordPauseButton_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordPauseButton()
    }
}

