//
//  AudioRecordStartButton.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

struct AudioRecordStartButton: View {
    
    var body: some View {
        Circle()
        .fill(.red)
        .frame(width: 30, height: 30)
        .overlay(
            Circle()
                .stroke(.red, lineWidth: 3)
                .frame(width: 40, height: 40)
        )
    }
}

struct AudioRecordStartButton_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordStartButton()
    }
}
