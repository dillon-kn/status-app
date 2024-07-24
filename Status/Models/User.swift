//
//  User.swift
//  Status
//
//  Created by Dillon Nguyen on 7/8/24.
//

import Foundation

struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let joined: TimeInterval
    let friends: [String]
}
