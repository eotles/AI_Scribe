//
//  HomeView.swift
//  AI_Scribe
//
//  Created by Erkin Otles on 6/30/23.
//

import SwiftUI

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm"
    return formatter.string(from: date)
}

func formattedTime(_ timeInterval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.allowedUnits = [.minute, .second]
    formatter.zeroFormattingBehavior = .pad
    return formatter.string(from: timeInterval) ?? "0:00"
}

struct HomeView: View {
    @ObservedObject var recordingsManager: RecordingsManager
    @State var showRecorder = false
    @State var showInfoView: Bool = false
    @State var refreshID = UUID()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recordingsManager.recordings.reversed()) { recording in
                    NavigationLink(destination: AudioFileDetailView(audioFile: recording,
                                                                    recordingsManager: recordingsManager,
                                                                    deletedCallback: { self.refreshID = UUID() })
                    ) {
                        
                        HStack {
                            Text("\(formatDate(recording.date))")
                            
                            Spacer()
                            
                            Text("\(formattedTime(recording.length))")
                            
                            Spacer()
                            
                            StatusIconView(isProcessed: .constant(recording.isProcessed))

                        }
                        
                    }
                }
                .onDelete(perform: deleteItems) // enable swipe to delete
            }
            .navigationTitle("Recordings")
            .toolbar {
                // Info Button
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showInfoView = true
                    }, label: {
                        Image(systemName: "ellipsis.circle")
                    })
                }
                
                // Total Recordings
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Text("Total Recordings: \(recordingsManager.recordings.count)")
                        Spacer()
                    }
                }
                
                // New Recording Button
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Spacer()
                        Button(action: {
                            showRecorder = true
                        }, label: {
                            HStack {
                                Text("New Recording")
                                Image(systemName: "plus.circle")
                            }
                        })
                    }
                }
                
                // Hidden NavigationLink for InfoView
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink("", destination: InfoView(), isActive: $showInfoView)
                }
            }
            .sheet(isPresented: $showRecorder) {
                AudioRecorderView(
                    audioRecorder: AudioRecorder(recordingsManager: recordingsManager),
                    doneRecording: {showRecorder = false})
            }
        }
        .id(refreshID) // This line forces SwiftUI to recreate the view when refreshID changes
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            recordingsManager.deleteRecording(recordingsManager.recordings.reversed()[index])
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(recordingsManager: RecordingsManager.shared)
    }
}



