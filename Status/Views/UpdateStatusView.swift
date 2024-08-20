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
    @Binding var newStatusPresented: Bool
    @FocusState private var focusedField: Field?
    
    enum Field {
        case status
    }
    
    var body: some View {
        ZStack {
            Color(hex: colorModel.beige)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        newStatusPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title)
                            .padding()
                            .foregroundColor(Color(hex: colorModel.forestGreen))
                    }
                    .padding(20)
                }
                
                
                Spacer()
                
                Text("Update Status")
                    .font(.system(size:32))
                    .bold()
                    .padding(.bottom, -10)

                
                Form {
                    TextField("New Status", text: $viewModel.newStatus)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .frame(minWidth: 100, maxWidth: 350, minHeight: 10, maxHeight: 70)
                        .multilineTextAlignment(.center)
                        .padding(7)
                        .focused($focusedField, equals: .status)

                    
                    SButton(
                        title: "Update Status",
                        background: Color(hex: colorModel.forestGreen)
                    ) {
                        if viewModel.canUpdate() {
                            viewModel.updateStatus()
                            newStatusPresented = false
                        }
                    }
                    .padding()
                
                }
                .frame(width: 350, height: 300)
                .scrollContentBackground(.hidden)
                
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
        .onTapGesture {
            focusedField = nil // dismiss keyboard
        }
    }
}

#Preview {
    UpdateStatusView(newStatusPresented: Binding(get: {
        return true
    }, set: {_ in
        
    }))
}
