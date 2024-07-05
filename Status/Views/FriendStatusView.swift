//
//  FriendStatusView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/5/24.
//

import SwiftUI

struct FriendStatusView: View {
    var name: String
    var status: String

    var body: some View {
        HStack {
            Text(name)
                .font(.body)
            Spacer()
            Text(status)
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 5)
    }
}

struct FriendStatusView_Previews: PreviewProvider {
    static var previews: some View {
        FriendStatusView(name:"you", status:"deadge")
    }
}
