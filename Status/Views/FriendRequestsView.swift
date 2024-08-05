//
//  FriendRequestsView.swift
//  Status
//
//  Created by Dillon Nguyen on 8/1/24.
//

// View of all friend requests, navigable from StatusView
import SwiftUI

struct FriendRequestsView: View {
    @StateObject var viewModel = FriendRequestsViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    
    var body: some View {
        VStack {
            Text("Friend Requests")
                .font(.title)
                .padding(.top, 50)
                .padding(.bottom, 1)
                .frame(maxWidth: .infinity, alignment: .center)
            
            ScrollView {
                VStack {
                    if !viewModel.friendRequests.isEmpty {
                        ForEach(viewModel.friendRequests) {request in
                            FriendRequestView(
                                firstName: request.firstName,
                                lastName: request.lastName,
                                username: request.username)
                        }
                    } else {
                        // TODO: Make default message/imsage for when no friend reqs
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(hex: colorModel.lightCream))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FriendRequestsView()
}
