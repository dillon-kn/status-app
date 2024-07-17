//
//  StatusViewViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 6/27/24.
//

import Foundation

class StatusViewViewModel: ObservableObject {
    @Published var currentStatus = "✨vibing✨"
    @Published var showingUpdateStatusView = false
    
    
    init() {}
}
 
