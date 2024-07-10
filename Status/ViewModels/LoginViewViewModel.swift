//
//  LoginViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import Foundation

class LoginViewViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    init() {}
}
 
