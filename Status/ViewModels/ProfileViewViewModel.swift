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
    
    init() {
        
    }
    
    func fetchUser() {
        guard let userID = Auth.auth().currentUser?.uid else {
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
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error Logging Out")
        }
    }
}
