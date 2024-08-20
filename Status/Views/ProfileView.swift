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
    let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    
    var body: some View {
        ZStack {
            Color(hex: colorModel.lightCream)
                .edgesIgnoringSafeArea(.all)
            
            NavigationView {
                VStack {
                    HStack {
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color(hex: colorModel.forestGreen))
                        }
                        .padding(.trailing, 3)

                    }
                    .padding(.top, 20)
                    .padding(.trailing)
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.top, 15)
                        .padding(.bottom, 20)
                        .foregroundStyle(Color(hex: colorModel.forestGreen))
                    
                    // Name + Username
                    VStack(alignment: .center) {
                        Text("\(viewModel.user?.firstName ?? "Nameless") \(viewModel.user?.lastName ?? "Person")")
                            .font(.system(.title, design: .serif))
                            .bold()
                            .padding(.bottom, 3)
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                            .multilineTextAlignment(.center)
                        
                        Text("\(viewModel.user?.username ?? "Usernameless User")")
                            .font(.system(.title3))
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    Text(viewModel.friendsMessage)
                        .font(.system(.title))
                        .foregroundStyle(Color(hex: colorModel.forestGreen))
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                    
                    Spacer()
                    
                    SButton(
                        title: "Log Out",
                        background: Color(hex: colorModel.forestGreen),
                        action: {
                            viewModel.logOut()
                    })
                    .frame(width: 100, height: 50)
                    .padding(50)
                }
                .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                    Button("OK", role: .cancel) {
                        // Message dismisses
                    }
                } message: { errorMessage in
                    Text(errorMessage)
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    ProfileView(userID: "8AOVYUeIsrUJR8yCQHJMsczvBZf2")
}
