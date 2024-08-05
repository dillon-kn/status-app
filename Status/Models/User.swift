//
//  User.swift
//  Status
//
//  Created by Dillon Nguyen on 7/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let username: String
    let email: String
    let phoneNumber: String
    let joined: Timestamp
}
