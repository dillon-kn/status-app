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
                    Spacer()
                    
                    Text("status")
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                    
                    Text("what's your status?")
                        .font(.system(.subheadline, design: .serif))
                    
                        
                    Form {
                        
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.system(.callout))
                                .bold()
                        }
                        
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        SButton(title: "Log In", background: Color(hex: colorModel.forestGreen)) {
                            viewModel.login()
                        }
                        .padding()
                    }
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                    .padding(.top, -20)
                    .padding(.bottom, -30)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                    
                    VStack {
                        Text("New around here?")
                        NavigationLink("Create an Account", destination: RegisterView())
                    }
                    .padding()
                }
                Spacer()
            }
            // Use .alert for error messages
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
