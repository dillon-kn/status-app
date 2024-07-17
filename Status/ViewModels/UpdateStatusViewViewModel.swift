//
//  UpdateStatusViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/17/24.
//

import Foundation

class UpdateStatusViewViewModel: ObservableObject {
    @Published var newStatus = ""
    @Published var showAlert = false
    @Published var errorTitle = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func updateStatus() {
        
    }
    
    private func validateStatus() {
        
    }
}
 
