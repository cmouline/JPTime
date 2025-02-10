//
//  Extension + View.swift
//  JPTTime
//
//  Created by Moulinet Chloë on 09/02/2025.
//

import SwiftUI

extension View {
    
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}
