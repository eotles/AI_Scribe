//
//  StatusIconView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 7/3/23.
//

import SwiftUI

struct StatusIconView: View {
    @State private var animate = false
    @Binding var isProcessed: Bool

    var body: some View {
        Image(systemName: !isProcessed ? "arrow.2.circlepath.circle.fill" : "checkmark.circle.fill")
            .foregroundColor(!isProcessed ? .yellow : .green)
            .rotationEffect(Angle.degrees(animate ? 360 : 0))
            .onAppear {
                self.animate = !isProcessed
            }
            .onChange(of: isProcessed) { newValue in
                self.animate = !newValue
            }
            .animation(animate ? Animation.linear(duration: 2).repeatForever(autoreverses: false) : .default, value: animate)
    }
}

struct StatusIconView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatusIconView(isProcessed: .constant(true))
                .previewDisplayName("Done Processing")
            
            StatusIconView(isProcessed: .constant(false))
                .previewDisplayName("Processing")
        }
        .previewLayout(.fixed(width: 50, height: 50))
    }
}
