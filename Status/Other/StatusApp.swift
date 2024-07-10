//
//  StatusApp.swift
//  Status
//
//  Created by Dillon Nguyen on 6/19/24.
//
import FirebaseCore
import SwiftUI

@main
struct StatusApp: App {
    init() {
        FirebaseApp.configure() // Configure Firebase
    }
    
    var body: some Scene {
        WindowGroup {
            StatusView()
        }
    }
}
