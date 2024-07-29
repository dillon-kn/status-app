//
//  FriendSearchView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/26/24.
//

import SwiftUI

struct FriendSearchView: View {
    @StateObject var viewModel = FriendSearchViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    @Binding var viewPresented: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        viewPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding()
                            .foregroundColor(Color(hex: colorModel.forestGreen))
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
                
                Button(action: {
                    print("searching for matching users")
                    viewModel.search()
                }) {
                    Text("Search")
                        .padding()
                        .background(Color(hex: colorModel.forestGreen))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 50)
                
                // TODO: MAKE SOME DEFAULT IF NOTHING BEING SHOWN
                if viewModel.searchResults.count > 0 {
                    Text("Results")
                        .font(.title)
                }
                List(viewModel.searchResults) { user in
                    VStack {
                        Text(user.username)
                        Text(user.firstName + " " + user.lastName)
                            .font(.caption)
                    }
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
            .background(Color(hex: colorModel.beige))
            .edgesIgnoringSafeArea(.all)
        }
    }
        
}

#Preview {
    FriendSearchView(viewPresented: Binding(get: {
        return true
    }, set: {_ in
        
    }))
}
