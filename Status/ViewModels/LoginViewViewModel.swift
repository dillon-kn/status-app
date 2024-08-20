//
//  LoginViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import Foundation
import FirebaseAuth

class LoginViewViewModel: ObservableObject {
    // TODO: ADD USERNAME SIGN IN FUNCTIONALITY
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
        // TODO: GET EMAIL FROM USERNAME
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error {
                self?.showAlert = true
                self?.errorTitle = "Login Error"
                self?.errorMessage = error.localizedDescription
            }
          }

    }
    
    private func validateInput() -> Bool {
        return true
    }
    
}
 
