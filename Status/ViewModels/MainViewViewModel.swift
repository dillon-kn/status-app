//
//  MainViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/12/24.
//

import FirebaseAuth
import Foundation

class MainViewViewModel: ObservableObject {
    @Published var currentUserID: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        let handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserID = user?.uid ?? ""
            }
        }
    }
    
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil // if currUser == nil, then not signed in, so return false
    }
}
