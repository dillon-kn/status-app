//
//  FriendSearchView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/26/24.
//

import SwiftUI

struct FriendSearchView: View {
    @StateObject var viewModel: FriendSearchViewViewModel
    @StateObject var colorModel = ColorViewModel()
    @Binding var viewPresented: Bool
    @FocusState private var focusedField: Field?
    
    enum Field {
        case search
    }
    
    init(viewPresented: Binding<Bool>, currentUserID: String) {
        self._viewPresented = viewPresented
        self._viewModel = StateObject(wrappedValue: FriendSearchViewViewModel(currentUserID: currentUserID))
    }
    
    var body: some View {
        ZStack {
            Color(hex: colorModel.beige)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding()
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                    }
                    .padding(20)
                }
                
                Text("Search for Friends")
                    .font(.system(size:32))
                    .bold()
                    .padding(.bottom, -5)
                
                TextField("Search by username", text: $viewModel.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(25.0)
                    .frame(minWidth: 100, maxWidth: 350, minHeight: 20, maxHeight: 70)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .background(Color(hex: colorModel.beige))
                    .focused($focusedField, equals: .search)

                
                Button(action: {
                    print("searching for matching users")
                    viewModel.search()
                }) {
                    Text("Search")
                        .padding()
                        .background(Color(hex: colorModel.forestGreen))
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 20)
                
                // TODO: MAKE SOME DEFAULT IF NOTHING BEING SHOWN
                List(viewModel.searchResults) { user in
                    HStack {
                        VStack {
                            Text(user.username)
                            Text(user.firstName + " " + user.lastName)
                                .font(.footnote)
                                .foregroundStyle(Color(.secondaryLabel))
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await viewModel.sendFriendRequest(to: user.id)
                            }
                        }) {
                            Image(systemName: "person.badge.plus")
                                .foregroundStyle(Color(hex: colorModel.forestGreen))
                        }
                        .disabled(viewModel.isSendingRequest) // Disable button while sending request
                    }
                    .background(Color(hex: colorModel.lightCream))
                }
                .listStyle(PlainListStyle())
                
                Spacer()

            }
            .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                Button("OK", role: .cancel) {
                    // Handle Action
                }
            } message: { errorMessage in
                Text(errorMessage)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .onTapGesture {
            focusedField = nil
        }
    }
        
}

#Preview {
    FriendSearchView(viewPresented: Binding(get: {
        return true
    }, set: {_ in
        
    }), currentUserID: "ee1GLVEWysSZbuayggaj3gFACOD3")
}
