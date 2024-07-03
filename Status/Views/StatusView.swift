//
//  ContentView.swift
//  Status
//
//  Created by Dillon Nguyen on 6/19/24.
//

import SwiftUI

// Extend Color to support hexadecimal color codes
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct StatusView: View {
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

                Text("a munch")
                    .font(.title)
                    .bold()
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)

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

struct FriendStatusView: View {
    var name: String
    var status: String

    var body: some View {
        HStack {
            Text(name)
                .font(.body)
            Spacer()
            Text(status)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
