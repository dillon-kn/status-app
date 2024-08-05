//
//  FriendRequest.swift
//  Status
//
//  Created by Dillon Nguyen on 8/5/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FriendRequest: Encodable {
    var to: String
    var from: String
    var timestamp: Timestamp
}
