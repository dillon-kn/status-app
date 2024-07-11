//
//  RegisterViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/11/24.
//

import Foundation

class RegisterViewViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var username = ""
    @Published var phoneNumber = ""
    @Published var email = ""
    @Published var password = ""
    
    init() {}
}
