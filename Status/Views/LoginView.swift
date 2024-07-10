//
//  LoginVIew.swift
//  Status
//
//  Created by Dillon Nguyen on 7/5/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack {
                    Text("status")
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                    
                    Text("what's your status?")
                        .font(.system(.subheadline, design: .serif))
                    
                    Form {
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        Button(action: {
                            // Attempt Login
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color(hex: colorModel.forestGreen))
                                
                                Text("Log In")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                    .frame(width: 300, height: 220)
                    .cornerRadius(10)
                    .padding(1)
                    
                    VStack {
                        Text("New around here?")
                        
                        Button("Create an Account") {
                            
                        }
                    }
                }
                Spacer()
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(50)
            .background(Color(hex: colorModel.lightCream))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
