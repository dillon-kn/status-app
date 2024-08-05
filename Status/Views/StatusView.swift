//
//  StatusView.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import SwiftUI
import FirebaseFirestoreSwift

struct StatusView: View {
    @StateObject var viewModel = StatusViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    @FirestoreQuery var friends: [String] // List of friends of user
    let userID: String
    
    init(userID: String) {
        self._friends = FirestoreQuery(
            collectionPath: "users/\(userID)/friends"
        )
        self.userID = userID
    }
    

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: FriendRequestsView()) {
                        Image(systemName: "person.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                    }
                        
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 23, height: 23)
                            .foregroundStyle(Color(hex: colorModel.forestGreen))
                    }
                    .padding(.leading, 3)
                    .padding(.trailing, 3)
                }
                .padding(.top, 20)
                .padding(.trailing)
                    
                VStack(alignment: .center) {
                    Text("right now, i'm...")
                        .font(.title2)
                        .padding(.top, 20)
                    
                    Text(viewModel.currentStatus.isEmpty ? "✨vibing✨" : viewModel.currentStatus)
                        .font(.system(.largeTitle, design: .serif))
                        .bold()
                        .padding()
                        .foregroundStyle(Color(hex: colorModel.forestGreen))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        viewModel.showingUpdateStatusView = true
                    }) {
                        Text("Update Status")
                            .padding()
                            .background(Color(hex: colorModel.forestGreen))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding(.vertical, 10)
                .alert(viewModel.errorTitle, isPresented: $viewModel.showAlert, presenting: viewModel.errorMessage) { errorMessage in
                    Button("OK", role: .cancel) {
                        // Message dismisses
                    }
                } message: { errorMessage in
                    Text(errorMessage)
                }
                
                Spacer()

                // Friends status section
                VStack(alignment: .leading) {
                    HStack {
                        Text("Friends")
                            .font(.title2)
                        Spacer()
                        Button(action: {
                            viewModel.showingFriendSearchView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
//                                .padding(.trailing)
                                .foregroundColor(Color(hex: colorModel.forestGreen))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                    
                    if friends.count > 0 {
                        // TODO: LOAD FRIENDS
                    } else {
                        // TODO: GET SOME FRIENDS message, maybe even create an aesthetic view for this (lowkey thinking like a poro type or smth xdd)
                        List {
                            FriendStatusView(name: "Esaw", status: "🎰 odds? 🎲")
                            FriendStatusView(name: "Naveen", status: "💭recalibrating")
                            FriendStatusView(name: "Shreyas", status: "grinding🧑‍🔬")
                            FriendStatusView(name: "Amogh", status: "amogging🗿")
                            FriendStatusView(name: "Matteo", status: "what the sigma 🎹")
                            FriendStatusView(name: "Nash", status: "pickle 🥒")
                            FriendStatusView(name: "Arun", status: "being tall 💂‍♂️")
                            FriendStatusView(name: "Dorian", status: "ima touch u 😈😈")
                            FriendStatusView(name: "Bodo", status: "im swiss 🍫")
                            FriendStatusView(name: "Gabriel", status: "I😘KARPATHIGHS")
                            FriendStatusView(name: "Peter", status: "🤑👨‍💻")
                            FriendStatusView(name: "Rohan", status: "rawdrawging🖼️")
                            FriendStatusView(name: "Ryan", status: "run 🏃‍♂️💨")
                            FriendStatusView(name: "Zhangyang", status: "😋 YUMMYYYY 🤤")
                            FriendStatusView(name: "Crystal", status: "robinson english major")
                            FriendStatusView(name: "Mau", status: "🤓 googling 🎶")
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingUpdateStatusView) {
                UpdateStatusView(newStatusPresented: $viewModel.showingUpdateStatusView)
            }
            .fullScreenCover(isPresented: $viewModel.showingFriendSearchView) {
                FriendSearchView(viewPresented: $viewModel.showingFriendSearchView, currentUserID: userID)
            }
            .padding(.top, 30)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(hex: colorModel.beige))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(userID: "ee1GLVEWysSZbuayggaj3gFACOD3")
    }
}
