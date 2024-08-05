//
//  FriendSearchViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/26/24.
//

import Foundation
import Combine
import FirebaseFirestore

@MainActor class FriendSearchViewViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults = [User]()
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var isSendingRequest = false // Track async sendFriendRequest
    
    private var cancellables = Set<AnyCancellable>()
    private var db = Firestore.firestore()
    private let currentUserID: String
    
    init(currentUserID: String) {
        self.currentUserID = currentUserID
    }

    func search() {
        let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        print("Searching for: \(trimmed)")
        db.collection("usernames")
            .whereField("username", isGreaterThanOrEqualTo: trimmed) // match all strings lexicographically >= input
            .whereField("username", isLessThanOrEqualTo: trimmed + "\u{f8ff}") // match all strings lexicographically <= input + letter after z
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.showAlert = true
                } else {
                    print("QuerySnapshot: \(querySnapshot?.documents ?? [])")
                    let userIDs = querySnapshot?.documents.compactMap { document in
                        document.data()["id"] as? String
                    } ?? []
                    print("Found user IDs: \(userIDs)")
                    self?.fetchUsers(userIDs: userIDs)
                }
            }
    }

    private func fetchUsers(userIDs: [String]) {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        var fetchedUsers = [User]()

        for userID in userIDs {
            print("Fetching user with ID: \(userID)")
            group.enter()
            db.collection("users").document(userID).getDocument { (document, error) in
                if let document = document, document.exists {
                    if let user = try? document.data(as: User.self) {
                        fetchedUsers.append(user)
                        print("Fetched user: \(user)")
                    } else {
                        print("Failed to decode user for document ID: \(userID)")
                    }
                } else {
                    print("No document found for user ID: \(userID)")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.searchResults = fetchedUsers
            print("All users fetched: \(fetchedUsers)")
        }
    }
    
    func sendFriendRequest(to userID: String) async {
        isSendingRequest = true
        defer {
            DispatchQueue.main.async {
                self.isSendingRequest = false
            }
        }
        
        do {
            // Make sure user isn't sending themselves
            if userID == currentUserID {
                await MainActor.run {
                    self.errorTitle = "Invalid Request"
                    self.errorMessage = "Cannot send friend request to self"
                    self.showAlert = true
                }
                return
            }
            
            // Check if request from currentUserID to userID exists
            let fromQuerySnapshot = try await db.collection("friend_requests")
                .whereField("from", isEqualTo: currentUserID)
                .whereField("to", isEqualTo: userID)
                .getDocuments()
            
            if !fromQuerySnapshot.isEmpty {
                await MainActor.run {
                    self.errorTitle = "Request Pending"
                    self.errorMessage = "Friend request already sent"
                    self.showAlert = true
                }
                return
            }
            
            // Check if request from userID to currentUserID exists
            let toQuerySnapshot = try await db.collection("friend_requests")
                .whereField("from", isEqualTo: userID)
                .whereField("to", isEqualTo: currentUserID)
                .getDocuments()
            
            if !toQuerySnapshot.isEmpty {
                let userDoc = try await db.collection("users").document(userID).getDocument()
                if let userFirstName = userDoc.data()?["firstName"] as? String {
                    await MainActor.run {
                        self.errorTitle = "Check friend requests!"
                        self.errorMessage = "\(userFirstName) has already sent you a friend request! Check your friend requests to accept."
                        self.showAlert = true
                    }
                } else {
                    await MainActor.run {
                        self.errorTitle = "Database Error"
                        self.errorMessage = "This user has no first name! Please contact support"
                        self.showAlert = true
                    }
                }
                return
            }
            
            // Create new friend request
            let friendRequest = FriendRequest(
                        to: userID,
                        from: currentUserID,
                        timestamp: Timestamp()
            )
            
            try await db.collection("friend_requests").addDocument(data: friendRequest.asDict())
            
            await MainActor.run {
                self.errorMessage = "Friend request sent successfully"
                self.showAlert = true
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
    }
}
