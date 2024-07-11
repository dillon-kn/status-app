//
//  RegisterView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/11/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()
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
                        TextField("First Name", text: $viewModel.firstName)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                        
                        TextField("Last Name", text: $viewModel.lastName)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                        
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        TextField("Phone Number", text: $viewModel.username)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.phonePad) // This sets the keyboard to phone pad
                        
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
                    .frame(width: 300, height: 420)
                    .cornerRadius(10)
                    .padding(1)
                    
                    VStack {
                        Text("Have an account?")
                        
                        Button("Go to Login") {
                            // Go to login page
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

#Preview {
    RegisterView()
}
