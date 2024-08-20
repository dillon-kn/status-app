//
//  ProfileViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/16/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewViewModel: ObservableObject {
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    @Published var user: User? = nil
    @Published var friendsCount: Int = 0
    @Published var friendsMessage: String = "Friends loading..."
    private var db = Firestore.firestore()
    private var userID: String?


    
    init() {
        guard let userID = Auth.auth().currentUser?.uid else {
            triggerAlert(title: "Authentication Error", message: "Unable to retrieve user ID")
            return
        }
        
        self.userID = userID
        self.fetchUser()
        self.fetchFriendsCount(userID: userID)
    }
    
    func fetchUser() {
        guard let userID = userID else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userID).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    username: data["username"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    phoneNumber: data["phoneNumber"] as? String ?? "",
                    joined: data["joined"] as? Timestamp ?? Timestamp()
                )
            }
        }
    }
    
    func fetchFriendsCount(userID: String) {
        db.collection("users").document(userID).collection("friends")
            .getDocuments { [weak self] snapshot, error in
                if error != nil {
                    self?.errorTitle = "Database Error"
                    self?.errorMessage = "Error fetching friend requests. Please contact support if this persists."
                    self?.showAlert = true
                    return
                }
                self?.friendsCount = snapshot?.documents.count ?? 0
                
                // Change friends message
                if let count = self?.friendsCount {
                    if count > 1 {
                        self?.friendsMessage = "You have \(count) friends!"
                    } else if count == 1 {
                        self?.friendsMessage = "You have friend!"
                    } else {
                        self?.friendsMessage = "You have no friends. Make some!"
                    }
                }
            }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error Logging Out")
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
