//
//  FriendRequestView.swift
//  Status
//
//  Created by Dillon Nguyen on 8/1/24.
//

// Individual friend request
import SwiftUI

struct FriendRequestView: View {
    @StateObject var viewModel = FriendRequestViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    @Binding var friendRequests: [FriendRequestDisplay]
    var request: FriendRequestDisplay

    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(request.username)
                Text(request.firstName + " " + request.lastName)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding(5)
            
            Spacer()
            
            Button(action: {
                viewModel.acceptReq(senderUsername: request.username, friendRequests: $friendRequests, requestID: request.id)
            }) {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color(hex: colorModel.forestGreen))
            }
            .padding(.trailing)
            
            Button(action: {
                viewModel.rejectReq(senderUsername: request.username, friendRequests: $friendRequests, requestID: request.id)
            }) {
                Image(systemName: "xmark")
                    .foregroundStyle(Color(hex: colorModel.red))
            }
        }
        .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
            Button("OK", role: .cancel) {
                // Message dismisses
            }
        } message: { errorMessage in
            Text(errorMessage)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(Color(hex: colorModel.lightCream))
    }
}

#Preview {
    FriendRequestView(friendRequests: .constant([]), request: FriendRequestDisplay(id: " ee1GLVEWysSZbuayggaj3gFACOD3 ", firstName: "B", lastName: "B", username: "bb"))
}
