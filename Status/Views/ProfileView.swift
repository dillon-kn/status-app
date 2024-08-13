//
//  ProfileView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/16/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                SButton(
                    title: "Log Out",
                    background: Color(hex: colorModel.forestGreen),
                    action: {
                        viewModel.logOut()
                })
                .frame(width: 100, height: 50)
                .padding()
            }
            .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                Button("OK", role: .cancel) {
                    // Message dismisses
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color(hex: colorModel.lightCream))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ProfileView()
}
