//
//  ColorViewModel.swift
//  Status
//
//  Created by Dillon Nguyen on 7/10/24.
//

import Foundation

class ColorViewModel: ObservableObject {
    @Published var forestGreen = "#014421"
    @Published var lightCream = "#fffff1"
    @Published var beige = "#eadabc"
    @Published var red = "#c23a22"
    
    init() {}
}
