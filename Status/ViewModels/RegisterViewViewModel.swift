//
//  RegisterViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var username = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    init() {}
     
    func register() {
        guard validateInput() else {
            print("input not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userID = result?.user.uid else {
                if let errorDescription = error?.localizedDescription {
                    print(errorDescription)
                }
                return
            }
            print("registering")
            self?.insertUserRecord(id: userID)
            // TODO: Add username to username-uID mapping database
        }
    }
    
    func validateInput() -> Bool {
        return true
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, firstName: firstName, lastName: lastName, username: username, email: email, phoneNumber: phoneNumber, joined: Date().timeIntervalSince1970) // Weird date because Firebase can't directly store normal dates
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDict()) {  error in
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                } else {
                    print("User \(id) registered with data \(newUser.asDict())")
                }
            }
    }
}
