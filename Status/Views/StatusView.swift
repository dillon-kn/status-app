//
//  ContentView.swift
//  Status
//
//  Created by Dillon Nguyen on 6/19/24.
//

import SwiftUI

struct StatusView: View {
    @State private var currentStatus: String = "a munch" // State variable to hold the current status

    var body: some View {
        VStack {
            // Title section
            Text("status")
                .font(.largeTitle)
                .padding(.top)

            // Current status section
            VStack(alignment: .center) {
                Text("right now, i'm...")
                    .font(.title2)
                    .padding(.bottom, 1)

                VStack {
                    TextEditor(text: $currentStatus)
                        .padding()
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 10, maxHeight: 70) // Dynamic height and minimum width
                        .multilineTextAlignment(.center)
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear // Makes TextEditor background transparent
                        }
                        .onChange(of: currentStatus) { newValue, oldValue in
                            currentStatus = newValue.replacingOccurrences(of: "\n", with: "")
                            if newValue.count > 30 {
                                currentStatus = String(newValue.prefix(30))
                            }
                        }
                    
                    Button(action: {
                        // Handle status submission
                        print("Status submitted: \(currentStatus)")
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }

            // Friends status section
            VStack(alignment: .leading) {
                HStack {
                    Text("Friends")
                        .font(.title2)
                    Spacer()
                    Button(action: {
                        // Add friend action
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .padding(.trailing)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)

                List {
                    FriendStatusView(name: "you", status: currentStatus)
                    FriendStatusView(name: "Jonathan", status: "tennis")
                    FriendStatusView(name: "Naveen", status: "recabibrating")
                    FriendStatusView(name: "Shreyas", status: "grinding")
                    FriendStatusView(name: "Amogh", status: "amogging")
                }
                .listStyle(PlainListStyle())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#eadabc")) // Use your custom color here
        .edgesIgnoringSafeArea(.all)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
