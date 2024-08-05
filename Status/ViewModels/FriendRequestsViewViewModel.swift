//
//  FriendRequestsViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 8/1/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FriendRequestsViewViewModel: ObservableObject {
    @Published var friendRequests: [FriendRequestDisplay] = []
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    private var db = Firestore.firestore()
    private var userID: String?

    init() {
        // Get current userID
        guard let userID = Auth.auth().currentUser?.uid else {
            self.errorTitle = "Authentication Error"
            self.errorMessage = "No user ID found. Please logout and sign back in, or contact support"
            self.showAlert = true
            return
        }
        self.userID = userID
        fetchFriendRequests()
    }
    
    func fetchFriendRequests() {
        guard let currentUserID = userID else {
            self.errorTitle = "Initialization Error"
            self.errorMessage = "No user ID found. Please logout and sign back in, or contact support"
            self.showAlert = true
            return
        }
        
        // Get all friend requests being sent to current user
        db.collection("friend_requests")
            .whereField("to", isEqualTo: currentUserID)
            .getDocuments { [weak self] querySnapshot, error in
                if error != nil {
                    self?.errorTitle = "Database Error"
                    self?.errorMessage = "Requests could not be found. Please contact support"
                    self?.showAlert = true
                    return
                }
                
                // Create a list to store friend requests
                var requests: [FriendRequestDisplay] = []
                let group = DispatchGroup()  // For handling async queries
                
                // Map documents to the list
                querySnapshot?.documents.forEach { doc in
                    let data = doc.data()
                    if let senderID = data["from"] as? String {
                        group.enter()  // Enter the group for each sender query
                        
                        self?.db.collection("users").document(senderID).getDocument { userDoc, error in
                            if let error = error {
                                self?.errorTitle = "Please Contact Support"
                                self?.errorMessage = error.localizedDescription
                                self?.showAlert = true
                                return
                            }
                            if let userDoc = userDoc, let userData = userDoc.data(),
                               let firstName = userData["firstName"] as? String,
                               let lastName = userData["lastName"] as? String,
                               let username = userData["username"] as? String {
                                print("userData: ", userData)
                                let request = FriendRequestDisplay(id: senderID, firstName: firstName, lastName: lastName, username: username)
                                requests.append(request)
                            }
                            group.leave()  // Leave the group after successful fetch
                        }
                    }
                    
                }
                
                // Update the published property
                group.notify(queue: .main) {
                    self?.friendRequests = requests
                }
            }
    }
}
