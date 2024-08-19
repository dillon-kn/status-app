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
import FirebaseFirestore
import FirebaseFirestoreSwift

class StatusViewViewModel: ObservableObject {
    @Published var currentStatus = ""
    @Published var showingUpdateStatusView = false
    @Published var showingFriendSearchView = false
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var friendRequestsCount: Int = 0
    @Published var friends: [FriendStatus] = []
    
    private var userID: String?
    private var ref: DatabaseReference?
    private var statusObserverHandle: DatabaseHandle?
    private var db = Firestore.firestore()

    init() {
        Task {
            await initialize()
        }
    }
    
    deinit {
        // Remove the observer when the instance is deallocated
        stopObservingStatusChanges()
    }
    
    private func initialize() async {
            guard let userID = Auth.auth().currentUser?.uid else {
                triggerAlert(title: "Authentication Error", message: "Unable to retrieve user ID")
                return
            }
            
            self.userID = userID
            self.ref = Database.database().reference().child("users").child(userID)
            
            observeStatusChanges()
            await fetchFriends()
        }

    func readValue() {
        guard let ref = self.ref else {
            triggerAlert(title: "Realtime Database Error", message: "Please contact support if this persists.")
            return
        }

        ref.observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String: Any],
                  let status = value["status"] as? String else {
                self.triggerAlert(title: "Realtime Database Error", message: "Failed to retrieve status. Please contact support if this persists")
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
    
//    func fetchFriends() {
//        guard let currentUserID = userID else {
//            triggerAlert(
//                title: "Initialization Error",
//                message: "No user ID found. Please logout and sign back in, or contact support"
//            )
//            return
//        }
//        
//        // Get all friends of user
//        db.collection("users")
//            .document(currentUserID)
//            .collection("friends")
//            .getDocuments { [weak self] querySnapshot, error in
//                if error != nil {
//                    self?.triggerAlert(title: "Database Error", message: "Issue retrieving friends. Please contact support if this issue continues.")
//                    return
//                }
//                
//                // Make list to store friends
//                var friends: [FriendStatus] = []
//                let group = DispatchGroup() // async queries
//                print("fetching friends of \(currentUserID)")
//                
//                querySnapshot?.documents.forEach { doc in
//                    let data = doc.data()
//                    var friendRef: DatabaseReference?
//                    if let friendID = data["id"] as? String {
//                        group.enter() // Enter the group for each query
//                        print("Accessing friend with ID \(friendID)")
//                        self?.db.collection("users").document(friendID).getDocument { friendDoc, error in
//                            if let error = error {
//                                self?.triggerAlert(title: "Error Retrieving Friends", message: error.localizedDescription)
//                                group.leave()
//                                return
//                            }
//                            if let friendDoc = friendDoc,
//                                let friendData = friendDoc.data(),
//                               let firstName = friendData["firstName"] as? String,
//                               let lastName = friendData["lastName"] as? String,
//                               let username = friendData["username"] as? String {
//                                // Now retrieve status
//                                friendRef = Database.database().reference().child("users").child(friendID)
//                                friendRef?.observeSingleEvent(of: .value) { snapshot, error in
//                                    if error != nil {
//                                        self?.triggerAlert(title: "Realtime Database Error", message: "Failed to find \(firstName). Please contact support if this persists.")
//                                        group.leave()
//                                        return
//                                    }
//                                    guard let value = snapshot.value as? [String: Any],
//                                          let status = value["status"] as? String else {
//                                        self?.triggerAlert(title: "Realtime Database Error", message: "Failed to retrieve status. Please contact support if this persists")
//                                        group.leave()
//                                        return
//                                    }
//                                    let friendStatus = status
//                                    print("Adding \(firstName + " " + lastName)")
//                                    let friend = FriendStatus(id: friendID, username: username, name: firstName + " " + lastName, status: friendStatus)
//                                    friends.append(friend)
//                                }
//                            }
//                            group.leave()
//                               
//                        }
//                    }
//                }
//                // Update the published property
//                group.notify(queue: .main) {
//                    self?.friends = friends
//                    print(friends)
//                }
//            }
//    }
//    func fetchFriends() async {
//        guard let currentUserID = userID else {
//            triggerAlert(
//                title: "Initialization Error",
//                message: "No user ID found. Please logout and sign back in, or contact support"
//            )
//            return
//        }
//        
//        do {
//            // Get all friends of user
//            let friendDocs = try await db.collection("users").document(currentUserID).collection("friends").getDocuments()
//            
//            // Make list to store friends
//            var friends: [FriendStatus] = []
//            print("fetching friends of \(currentUserID)")
//            
//            for doc in friendDocs.documents {
//                let data = doc.data()
//                if let friendID = data["id"] as? String {
//                    print("Accessing friend with ID \(friendID)")
//                    
//                    // Retrieve friend's document
//                    let friendDoc = try await db.collection("users").document(friendID).getDocument()
//                    guard let friendData = friendDoc.data(),
//                          let firstName = friendData["firstName"] as? String,
//                          let lastName = friendData["lastName"] as? String,
//                          let username = friendData["username"] as? String else {
//                        // Handle missing friend data
//                        continue
//                    }
//                    
//                    // Retrieve status
//                    let friendRef = Database.database().reference().child("users").child(friendID)
//                    let statusSnapshot = try await friendRef.observeSingleEvent(of: .value).getSnapshot()
//                    
//                    guard let value = statusSnapshot.value as? [String: Any],
//                          let status = value["status"] as? String else {
//                        triggerAlert(title: "Realtime Database Error", message: "Failed to retrieve status for \(firstName). Please contact support if this persists.")
//                        continue
//                    }
//                    
//                    let friend = FriendStatus(id: friendID, username: username, name: firstName + " " + lastName, status: status)
//                    friends.append(friend)
//                }
//            }
//            
//            // Update the published property
//            self.friends = friends
//            print(friends)
//            
//        } catch {
//            triggerAlert(title: "Database Error", message: "An error occurred while fetching friends. Please contact support if this issue continues.")
//        }
//    }
//
    
    @MainActor
    func fetchFriends() async {
        guard let currentUserID = userID else {
            triggerAlert(title: "Initialization Error", message: "No user ID found.")
            return
        }

        do {
            let friendDocs = try await db.collection("users").document(currentUserID).collection("friends").getDocuments()

            var friends: [FriendStatus] = []

            for doc in friendDocs.documents {
                if let friendID = doc.data()["id"] as? String {
                    // Get friend data
                    let friendDoc = try await db.collection("users").document(friendID).getDocument()
                    guard let friendData = friendDoc.data(),
                          let firstName = friendData["firstName"] as? String,
                          let lastName = friendData["lastName"] as? String,
                          let username = friendData["username"] as? String else {
                        print("Could not find data for \(friendID), friend of \(userID ?? "")")
                        continue
                    }

                    // Retrieve friend's status from Realtime Database
                    let friendRef = Database.database().reference().child("users").child(friendID)
                    friendRef.observe(DataEventType.value, with: { [weak self] snapshot in
                        guard let value = snapshot.value as? [String: Any],
                              let status = value["status"] as? String else {
                            print("Could not find status for \(friendID), friend of \(self?.userID ?? "")")
                            return
                        }

                        let friend = FriendStatus(id: friendID, username: username, name: "\(firstName) \(lastName)", status: status)
                        // Update the friends array on the main thread
                        Task { @MainActor in
                            if let index = friends.firstIndex(where: { $0.id == friendID }) {
                                // Update the existing friend's status
                                friends[index] = friend
                            } else {
                                // Append new friend
                                friends.append(friend)
                            }
                            self?.friends = friends
                        }
                    })
                }
            }
        } catch {
            triggerAlert(title: "Error Retrieving Friends", message: error.localizedDescription)
        }
    }

    
    func fetchFriendRequestsCount(userID: String) {
        db.collection("friend_requests").whereField("to", isEqualTo: userID)
            .getDocuments { [weak self] snapshot, error in
                if error != nil {
                    self?.errorTitle = "Database Error"
                    self?.errorMessage = "Error fetching friend requests. Please contact support if this persists."
                    self?.showAlert = true
                    return
                }
                self?.friendRequestsCount = snapshot?.documents.count ?? 0
            }
    }
    
    private func triggerAlert(title: String, message: String) {
        DispatchQueue.main.async {
            self.showAlert = true
            self.errorTitle = title
            self.errorMessage = message
            return
        }
    }
}
