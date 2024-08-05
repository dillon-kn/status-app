//
//  FriendRequest.swift
//  Status
//
//  Created by Dillon Nguyen on 8/3/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FriendRequestDisplay: Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var username: String
}
