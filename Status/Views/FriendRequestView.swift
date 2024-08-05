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
    var firstName: String
    var lastName: String
    var username: String

    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(username)
                Text(firstName + " " + lastName)
                    .font(.footnote)
                    .foregroundStyle(Color(.secondaryLabel))
            }
            .padding(5)
            
            Spacer()
            
            Button(action: {
                viewModel.acceptReq(senderUsername: username)
            }) {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color(hex: colorModel.forestGreen))
            }
            .padding(.trailing)
            
            Button(action: {
                viewModel.rejectReq(senderUsername: username)
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
    FriendRequestView(firstName: "Eugene", lastName: "Tao", username: "etao96")
}
