//
//  LoginViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validateInput() else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validateInput() -> Bool {
        return true
    }
    
}
 
