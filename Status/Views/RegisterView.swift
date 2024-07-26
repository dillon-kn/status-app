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
                    Spacer()
                    
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
                        
                        TextField("Phone Number", text: $viewModel.phoneNumber)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                            .keyboardType(.phonePad) // This sets the keyboard to phone pad
                        
                        TextField("Username", text: $viewModel.username)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        TextField("Email Address", text: $viewModel.email)
                            .textFieldStyle(DefaultTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        SecureField("Confirm Password", text: $viewModel.confirmPassword)
                            .textFieldStyle(DefaultTextFieldStyle())
                        
                        SButton(title: "Register", background: Color(hex: colorModel.forestGreen)) {
                            viewModel.register()
                        }
                        .padding()
                    }
                    .frame(width: 300, height: 450)
                    .cornerRadius(10)
                    .padding(.top, -20)
                    .padding(.bottom, -30)
                    .scrollContentBackground(.hidden)
                    
                    Spacer()
                }
                Spacer()
            }
            .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                Button("OK", role: .cancel) {
                    // Handle Action
                }
            } message: { errorMessage in
                Text(errorMessage)
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
