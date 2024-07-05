//
//  LoginView.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
            NavigationLink("Login",
                           destination: StatusView())
        }
        .padding()
        .navigationTitle("Login")

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
