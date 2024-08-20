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
    @FocusState private var focusedField: Field?
    
    enum Field {
        case firstName, lastName, phoneNumber, username, email, password, confirmPassword
    }
    
    var body: some View {
        ZStack {
            Color(hex: colorModel.beige)
                .edgesIgnoringSafeArea(.all)
            
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
                                .focused($focusedField, equals: .firstName)

                            
                            TextField("Last Name", text: $viewModel.lastName)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .focused($focusedField, equals: .lastName)

                            
                            TextField("Phone Number", text: $viewModel.phoneNumber)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                .keyboardType(.phonePad) // sets keyboard to phone pad
                                .focused($focusedField, equals: .phoneNumber)

                            
                            TextField("Username", text: $viewModel.username)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                .focused($focusedField, equals: .username)

                            
                            TextField("Email Address", text: $viewModel.email)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                .focused($focusedField, equals: .email)

                            
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .focused($focusedField, equals: .password)

                            
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .focused($focusedField, equals: .confirmPassword)

                            
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
                .padding(50)
                .background(Color(hex: colorModel.lightCream))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onTapGesture {
            focusedField = nil // dismiss keyboard
        }
    }

}

#Preview {
    RegisterView()
}
