//
//  MainView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/12/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserID.isEmpty {
            StatusView(userID: viewModel.currentUserID)
        } else {
            LoginView()
        }
    }
    
//    @ViewBuilder
//    var accountView: some View {
//        TabView {
//            StatusView(userID: viewModel.currentUserID)
//                .tabItem {
//                    Label("Status", systemImage: "square")
//                }
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.circle")
//                }
//        }
//    }
}

#Preview {
    MainView()
}
