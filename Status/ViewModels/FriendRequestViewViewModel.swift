//
//  FriendRequestViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 8/2/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FriendRequestViewViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    private var userID: String?
    private var db = Firestore.firestore()
    
    init() {
        // Get current user ID
        guard let userID = Auth.auth().currentUser?.uid else {
            showAlert = true
            errorTitle = "Authentication Error"
            errorMessage = "Unable to retrieve user ID"
            return
        }
        
        self.userID = userID
    }
    
    
    func acceptReq(senderUsername: String) {
        guard let currentUserID = userID else {
            self.errorTitle = "Authentication Error"
            self.errorMessage = "No user ID found. Please logout and sign back in, or contact support"
            self.showAlert = true
            return
        }
        
        // Get uID from username        
        db.collection("usernames").document(senderUsername).getDocument { [weak self] document, error in
            if error != nil {
                self?.errorTitle = "Database Error"
                self?.errorMessage = "Request could not be found. Please contact support"
                self?.showAlert = true
                return
            }
            
            guard let document = document, let senderUserID = document.data()?["id"] as? String else {
                self?.errorTitle = "Invalid Action"
                self?.errorMessage = "Sender request could not be found. Please contact support"
                self?.showAlert = true
                return
            }
            
            // Start a batch write to add friends to each other's collection
            let batch = self?.db.batch()
            let timestamp = Timestamp()
            
            // Add documents to each others' friends' collections
            guard let curUserFriendsRef = self?.db.collection("users").document(currentUserID).collection("friends").document(senderUserID) else {
                self?.errorTitle = "Database Error"
                self?.errorMessage = "Error adding friend. Please contact support."
                self?.showAlert = true
                return
            }
            guard let senderFriendsRef = self?.db.collection("users").document(senderUserID).collection("friends").document(currentUserID) else {
                self?.errorTitle = "Database Error"
                self?.errorMessage = "Error adding friend. Please contact support."
                self?.showAlert = true
                return
            }
            
            batch?.setData(["friendSince": timestamp], forDocument: curUserFriendsRef)
            batch?.setData(["friendSince": timestamp], forDocument: senderFriendsRef)
            
            // Remove friend request from database
            self?.db.collection("friend_requests").whereField("from", isEqualTo: senderUserID)
                .whereField("to", isEqualTo: currentUserID)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        self?.errorTitle = "Error"
                        self?.errorMessage = error.localizedDescription
                        self?.showAlert = true
                        return
                    }
                    
                    // Get friend request doc (should only be one)
                    guard let requestDocument = querySnapshot?.documents.first else {
                        self?.errorTitle = "Friend Request Not Found"
                        self?.errorMessage = "Please contact support."
                        self?.showAlert = true
                        return
                    }
                    
                    // Delete doc
                    batch?.deleteDocument(requestDocument.reference)
                    
                    // Commit the batch
                    batch?.commit { error in
                        if let error = error {
                            self?.errorTitle = "Friend Request Error"
                            self?.errorMessage = error.localizedDescription
                            self?.showAlert = true
                        } else {
                            let senderFirstName = document.data()?["firstName"] as? String ?? senderUsername
                            self?.errorTitle = "Friend Request Successful"
                            self?.errorMessage = "Congrats! You and \(senderFirstName) are besties now!"
                            self?.showAlert = true
                        }
                    }
                }
        }
    }
    
    func rejectReq(senderUsername: String) {
        guard let currentUserID = userID else {
            self.errorTitle = "Authentication Error"
            self.errorMessage = "No user ID found. Please logout and sign back in, or contact support"
            self.showAlert = true
            return
        }
        // Get uID from username
        db.collection("usernames").document(senderUsername).getDocument { [weak self] document, error in
            if error != nil {
                self?.errorTitle = "Database Error"
                self?.errorMessage = "Request could not be found. Please contact support"
                self?.showAlert = true
                return
            }
            
            guard let document = document, let senderUserID = document.data()?["id"] as? String else {
                self?.errorTitle = "Invalid Action"
                self?.errorMessage = "Sender request could not be found. Please contact support"
                self?.showAlert = true
                return
            }

            // Remove friend request from database
            self?.db.collection("friend_requests").whereField("from", isEqualTo: senderUserID)
                .whereField("to", isEqualTo: currentUserID)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        self?.errorTitle = "Error"
                        self?.errorMessage = error.localizedDescription
                        self?.showAlert = true
                        return
                    }
                    
                    // Get friend request doc (should only be one)
                    guard let requestDocument = querySnapshot?.documents.first else {
                        self?.errorTitle = "Friend Request Not Found"
                        self?.errorMessage = "Please contact support."
                        self?.showAlert = true
                        return
                    }

                    // Delete the friend request document
                    requestDocument.reference.delete { error in
                        if let error = error {
                            self?.errorTitle = "Friend Request Error"
                            self?.errorMessage = error.localizedDescription
                            self?.showAlert = true
                        } else {
                            self?.errorTitle = "Friend Request Rejected"
                            self?.errorMessage = "You have successfully rejected the friend request."
                            self?.showAlert = true
                        }
                    }
                }
        }
    }
}
