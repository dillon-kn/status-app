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
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: colorModel.beige)
                    .edgesIgnoringSafeArea(.all)
                    
                VStack(spacing: 10) {
                    Spacer()
                    
                    Text("status")
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                    
                    Text("what's your status?")
                        .font(.system(.subheadline, design: .serif))
                        .padding(.bottom, 15)
                
                    VStack {
                        VStack(spacing: 15) {
                            Spacer()
                            
                            TextField("Email Address", text: $viewModel.email)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                                .focused($focusedField, equals: .email)
                            
                            SecureField("Password", text: $viewModel.password)
                                .textFieldStyle(DefaultTextFieldStyle())
                                .focused($focusedField, equals: .password)
                            
                            SButton(title: "Log In", background: Color(hex: colorModel.forestGreen)) {
                                viewModel.login()
                            }
                            .padding()
                            .frame(minWidth: 110, idealWidth: 120, maxWidth: 130, minHeight: 80, idealHeight: 80, maxHeight: 80)
                            
                            Spacer()
                        }
                        .padding(15)
                        .padding(.top, 15)
//                        .padding(.bottom, -25)
                    }
                    .frame(minWidth: 150, idealWidth: 300, maxWidth: 300, minHeight: 150, idealHeight: 150, maxHeight: 170)
                    .background(Color(hex: colorModel.lightCream))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    VStack {
                        Text("New around here?")
                        NavigationLink("Create an Account", destination: RegisterView())
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                            .bold()
                    }
                    .padding()
                }
                .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                    Button("OK", role: .cancel) {
                        // Message dismisses
                    }
                } message: { errorMessage in
                    Text(errorMessage)
                }
//                .padding(.bottom, 25)
            }
            .onTapGesture {
                focusedField = nil // dismiss keyboard
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
