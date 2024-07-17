//
//  UpdateStatusView.swift
//  Status
//
//  Created by Dillon Nguyen on 7/17/24.
//

import SwiftUI

struct UpdateStatusView: View {
    @StateObject var viewModel = UpdateStatusViewViewModel()
    @StateObject var colorModel = ColorViewModel()
    
    var body: some View {
        VStack {
            Text("Update Status")
                .font(.system(size:32))
                .bold()
            
            
            Form {
                TextField("New Status", text: $viewModel.newStatus)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
                    .frame(minWidth: 100, maxWidth: 350, minHeight: 10, maxHeight: 70)
                    .multilineTextAlignment(.center)
                    .padding(7)
                
                SButton(title: "Update Status", background: Color(hex: colorModel.forestGreen)) {
                    viewModel.updateStatus()
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            
            Text("Note that statuses must be less than 30 characters and not include newlines or tabs.")
                .padding()
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .padding(.top, -100)
            
            Spacer()

        }
        .padding(.top, 100)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: colorModel.beige))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // dismiss keyboard when done
        }
    }
}

#Preview {
    UpdateStatusView()
}
