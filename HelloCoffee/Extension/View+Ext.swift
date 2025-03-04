//
//  View+Ext.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import Foundation
import SwiftUI

extension View {
    func centerHorizontally() -> some View {
        HStack {
            Spacer()
            self
            Spacer()
        }
    }
    
    @ViewBuilder //make can return opaque view
    func visible(_ value: Bool) -> some View {
        switch value {
        case true:
            self
        case false:
            EmptyView()
        }
    }
}
