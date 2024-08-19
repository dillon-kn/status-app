//
//  FriendStatusModel.swift
//  Status
//
//  Created by Dillon Nguyen on 8/16/24.
//

import Foundation

struct FriendStatus: Encodable, Identifiable {
    var id: String
    var username: String
    var name: String
    var status: String
}
