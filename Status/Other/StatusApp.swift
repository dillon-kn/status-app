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
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}
