//
//  AudioRecordResumeButton.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

struct AudioRecordResumeButton: View {
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(.red.opacity(0.5))
                .frame(width: 90, height: 30)
            
            Text("Resume")
                .foregroundColor(.red)
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 40)
                .overlay(
                    Capsule().stroke(.red, lineWidth: 3)
                )
        }
    }
}

struct AudioRecordResumeButton_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordResumeButton()
    }
}
