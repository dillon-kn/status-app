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
    let userID: String
    
    init(userID: String) {
        self.userID = userID
    }
    

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: FriendRequestsView()) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 23, height: 23)
                                .foregroundStyle(Color(hex: colorModel.forestGreen))
                            
                            if viewModel.friendRequestsCount > 0 {
                                Text("\(viewModel.friendRequestsCount)")
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                                    .bold()
                                    .offset(x: 3, y: -12)
                            }
                        }
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
                    .padding(.top, 10)
                    
                    // TODO: FIX THS SPACING FOR WHEN YOU HAVE NO FRIENDS
                    if !viewModel.friends.isEmpty {
                        ForEach(viewModel.friends) {friend in
                            FriendStatusView(
                                username: friend.username,
                                name: friend.name,
                                status: friend.status
                            )
                        }
                    } else {
                        // TODO: GET SOME FRIENDS message, maybe even create an aesthetic view for this (lowkey thinking like a poro type or smth xdd)
                        List {
                            FriendStatusView(username: "eadhana", name: "Esaw", status: "🎰 odds? 🎲")
                                .listRowInsets(EdgeInsets())
                            FriendStatusView(username: "nkannan", name: "Naveen", status: "💭recalibrating").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "sa27", name: "Shreyas", status: "grinding🧑‍🔬").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "sirchaturvedi", name: "Amogh", status: "amogging🗿").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "swisswhistler", name: "Matteo", status: "what the sigma 🎹").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "ncbrown", name: "Nash", status: "pickle 🥒").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "amoorthy", name: "Arun", status: "being tall 💂‍♂️").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "folsom", name: "Dorian", status: "ima touch u 😈😈").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "iswearimswiss", name: "Bodo", status: "im swiss 🍫").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "mllover", name: "Gabriel", status: "I😘KARPATHIGHS").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "piggybank49320", name: "Peter", status: "🤑👨‍💻").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "chachashabada", name: "Rohan", status: "rawdrawging🖼️").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "rizzbizz", name: "Ryan", status: "run 🏃‍♂️💨").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "ohsoyummy", name: "Zhangyang", status: "😋 YUMMYYYY 🤤").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "yearnforpengu", name: "Crystal", status: "yearningforpenguins").listRowInsets(EdgeInsets())
                            FriendStatusView(username: "elgoogler", name: "Mau", status: "🤓 googling 🎶").listRowInsets(EdgeInsets())
                        }
                        .listStyle(PlainListStyle())
                    }
                    
                    Spacer()
                }
            }
            .fullScreenCover(isPresented: $viewModel.showingUpdateStatusView) {
                UpdateStatusView(newStatusPresented: $viewModel.showingUpdateStatusView)
            }
            .fullScreenCover(isPresented: $viewModel.showingFriendSearchView) {
                FriendSearchView(viewPresented: $viewModel.showingFriendSearchView, currentUserID: userID)
            }
            .onAppear {
                viewModel.fetchFriendRequestsCount(userID: userID)
                Task {
                    await viewModel.fetchFriends()
                }
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
        StatusView(userID: "ATeZ6gYQzKh5Ih6NMxdYbdRFRU53")
    }
}
