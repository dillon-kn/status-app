//
//  UpdateStatusViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/17/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift

class UpdateStatusViewViewModel: ObservableObject {
    @Published var newStatus = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func updateStatus() {
        guard canUpdate() else {
            return
        }
        
        // Get current user ID
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert = true
            errorTitle = "Authentication Error"
            errorMessage = "Unable to retrieve user ID"
            return
        }
        
        // Sanitize the new status
        newStatus = sanitizeTextEntry(newStatus)
        
        // Write new (validated) status to realtime database
        let ref = Database.database().reference().child("users").child(userID)
        let timestamp = ISO8601DateFormatter().string(from: Date())
        
        let statusUpdate = [
            "status": newStatus,
            "lastUpdated": timestamp
        ]
        
        ref.updateChildValues(statusUpdate) { error, _ in
            if let error = error {
                self.showAlert = true
                self.errorTitle = "Update Error"
                self.errorMessage = "Error updating status: \(error.localizedDescription)"
                print("Error updating status: \(error.localizedDescription)")
            }
        }
        
        
    }
    
    // Validate that status follows guidelines
    func canUpdate() -> Bool {
        guard !newStatus.contains("\n") && !newStatus.contains("\t") else {
            showAlert = true
            errorTitle = "Invalid Status Input"
            errorMessage = "Status cannot contain newlines or tabs"
            return false
        }
        
        guard !newStatus.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert = true
            errorTitle = "Invalid Status Input"
            errorMessage = "Status must be non-empty"
            return false
        }
        
        guard newStatus.trimmingCharacters(in: .whitespaces).count <= 30 else {
            showAlert = true
            errorTitle = "Invalid Status Input"
            errorMessage = "Status cannot exceed 30 characters"
            return false
        }
        
        return true
    }
    
    private func sanitizeTextEntry(_ text: String) -> String {
        // Get rid of leading/trailing whitespace
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        
        // Convert the string to UTF-8 data
        guard let utf8Data = trimmed.data(using: .utf8) else {
            return "" // Return empty string if conversion to UTF-8 fails
        }
        
        // Attempt to create a new string from the UTF-8 data
        guard let sanitizedString = String(data: utf8Data, encoding: .utf8) else {
            return "" // Return empty string if conversion from UTF-8 fails
        }
        
        // Return the sanitized string
        return sanitizedString
    }
}
 
