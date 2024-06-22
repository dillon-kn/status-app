//
//  ContentView.swift
//  Status
//
//  Created by Dillon Nguyen on 6/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var statusText: String = ""
    @State private var selectedActivity: String = "Idle"
    let activities = ["Idle", "Climbing", "Reading", "Working", "Sleeping"]

    var body: some View {
        NavigationView {
            VStack {
                TextField("Update your status...", text: $statusText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Picker("Select an activity", selection: $selectedActivity) {
                    ForEach(activities, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Button(action: {
                    // Handle status update
                    updateStatus()
                }) {
                    Text("Update Status")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Status")
        }
    }

    func updateStatus() {
        // Implement the logic to update status
        print("Status updated to \(statusText) - \(selectedActivity)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
