//
//  StatusViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

class StatusViewViewModel: ObservableObject {
    @Published var currentStatus = ""
    @Published var showingUpdateStatusView = false
    @Published var showingFriendSearchView = false
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    private var userID: String?
    private var ref: DatabaseReference?
    private var statusObserverHandle: DatabaseHandle?

    init() {
        // Get current user ID
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert = true
            errorTitle = "Authentication Error"
            errorMessage = "Unable to retrieve user ID"
            return
        }
        
        self.userID = userID
        self.ref = Database.database().reference().child("users").child(userID)
        
        // Start observing status changes
        observeStatusChanges()
    }
    
    deinit {
        // Remove the observer when the instance is deallocated
        stopObservingStatusChanges()
    }

    func readValue() {
        guard let ref = self.ref else {
            showAlert = true
            errorTitle = "Error"
            errorMessage = "Database reference is not available"
            return
        }

        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let status = value["status"] as? String else {
                self.showAlert = true
                self.errorTitle = "Error"
                self.errorMessage = "Failed to retrieve status"
                return
            }

            self.currentStatus = status
        }
    }
    
    private func observeStatusChanges() {
        guard let ref = self.ref else {
            showAlert = true
            errorTitle = "Error"
            errorMessage = "Database reference is not available"
            return
        }
        
        statusObserverHandle = ref.observe(.value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let status = value["status"] as? String else {
                self.showAlert = true
                self.errorTitle = "Error"
                self.errorMessage = "Failed to retrieve status"
                return
            }
            
            self.currentStatus = status
        }
    }
    
    private func stopObservingStatusChanges() {
        if let ref = self.ref, let handle = statusObserverHandle {
            ref.removeObserver(withHandle: handle)
        }
    }
}
