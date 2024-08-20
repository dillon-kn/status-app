//
//  FriendStatusView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/5/24.
//

import SwiftUI

struct FriendStatusView: View {
    var username: String
    var name: String
    var status: String
    @StateObject var colorModel = ColorViewModel()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 15))
                Text(username)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))

            }
            .padding(.horizontal, 15)

            
            Spacer()
            
            Text(status)
                .font(.system(size: 15))
                .foregroundColor(.gray)
                .padding(.trailing, 15)
        }
        .padding(.vertical, 10)
        .background(Color(hex: colorModel.lightCream))
    }
}

struct FriendStatusView_Previews: PreviewProvider {
    static var previews: some View {
        FriendStatusView(username: "meh", name:"you are so", status:"deadge")
    }
}
