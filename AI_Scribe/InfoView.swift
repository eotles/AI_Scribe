//
//  InfoView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 7/7/23.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Created by Erkin Ötleş. \n Aided by ChatGPT4.")
            
            Spacer()
            
            Text("2023")
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
