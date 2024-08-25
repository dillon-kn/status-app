//
//  RegisterViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/11/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseFirestore
import FirebaseFirestoreSwift

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
        print("Registering \(username)")
        guard validateInput() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            guard let userID = result?.user.uid else {
                if let errorDescription = error?.localizedDescription {
                    self.triggerAlert(title: "Registration Error", message: errorDescription)
                }
                return
            }
            
            self.insertUserRecord(id: userID) { success in
                guard success else { return }
            }
            
            self.addUsername(username: self.username, id: userID) { success in
                guard success else { return }
            }
            
            self.createStatus(id: userID)
            
            // Registration successful
            self.triggerAlert(title: "Success", message: "You are registered!")
        }
    }
    
    func validateInput() -> Bool {
        let firstNameParts = firstName.split(separator: " ")
        guard firstName.count >= 2, firstName.count <= 50,
              firstNameParts.allSatisfy({ $0.range(of: "^[a-zA-Z'-]+$", options: .regularExpression) != nil }) else {
            triggerAlert(title: "Registration Error", message: "Last name must be 2-50 characters and only contain letters, apostrophes, spaces, and hyphens")
            return false
        }
        
        let lastNameParts = lastName.split(separator: " ")
        guard lastName.count >= 2, lastName.count <= 50,
              lastNameParts.allSatisfy({ $0.range(of: "^[a-zA-Z'-]+$", options: .regularExpression) != nil }) else {
            triggerAlert(title: "Registration Error", message: "Last name must be 2-50 characters and only contain letters, apostrophes, spaces, and hyphens")
            return false
        }
        
        guard username.count >= 3, username.count <= 30, username.range(of: "^[a-zA-Z0-9_]+$", options: .regularExpression) != nil else {
            triggerAlert(title: "Registration Error", message: "Username must be 2-50 characters and only contain letters, apostrophes, and hyphens")
            return false
        }
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        guard emailPredicate.evaluate(with: email) else {
            triggerAlert(title: "Registration Error", message: "Invalid Email")
            return false
        }
        
        let phoneRegex = "^\\d{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        guard phonePredicate.evaluate(with: phoneNumber) else {
            triggerAlert(title: "Registration Error", message: "Invalid Phone Number")
            return false
        }
        
        guard password.count >= 8 else {
            triggerAlert(title: "Registration Error", message: "Password must be at least 8 characters")
            return false
        }
                
        guard password.range(of: ".*[A-Z]+.*", options: .regularExpression) != nil else {
            triggerAlert(title: "Registration Error", message: "Password must contain at least one uppercase letter")
            return false
        }
        
        guard password.range(of: ".*[a-z]+.*", options: .regularExpression) != nil else {
            triggerAlert(title: "Registration Error", message: "Password must contain at least one lowercase letter")
            return false
        }
        
        guard password.range(of: ".*[0-9]+.*", options: .regularExpression) != nil else {
            triggerAlert(title: "Registration Error", message: "Password must contain at least one number")
            return false
        }
        
        guard password.range(of: ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?]+.*", options: .regularExpression) != nil else {
            triggerAlert(title: "Registration Error", message: "Password must contain at least one special character")
            return false
        }

        guard confirmPassword == password else {
            triggerAlert(title: "Registration Error", message: "Passwords must match")
            return false
        }
        
        return true
    }
    
    private func insertUserRecord(id: String, completion: @escaping (Bool) -> Void) {
        let newUser = User(id: id, firstName: firstName, lastName: lastName, username: username, email: email, phoneNumber: phoneNumber, joined: Timestamp(date: Date())) // Weird date because Firebase can't directly store normal dates
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(newUser.asDict()) {  error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.triggerAlert(title: "Database Error", message: error.localizedDescription)
                        print(error.localizedDescription)
                        completion(false)
                    } else {
                        self.triggerAlert(title: "Success", message: "You are registered!")
                        completion(true)
                    }
                }
            }
    }
    
    private func addUsername(username: String, id: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        
        
        db.collection("usernames")
            .document(username)
            .setData([
                "username": username,
                "id": id
            ]) { error in
                DispatchQueue.main.async {
                    if let error = error {
                        self.triggerAlert(title: "Database Error", message: error.localizedDescription)
                        print(error.localizedDescription)
                        completion(false)
                    } else {
                        self.triggerAlert(title: "Success", message: "You are registered!")
                        completion(true)
                    }
                }
            }
    }
    
    private func createStatus(id: String) {
        let ref = Database.database().reference().child("users").child(id)
        let timestamp = ISO8601DateFormatter().string(from: Date())
        
        let statusUpdate = [
            "status": "✨vibing✨",
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
    
    private func triggerAlert(title: String, message: String) {
        showAlert = true
        errorTitle = title
        errorMessage = message
        return
    }
}
