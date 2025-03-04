//
//  String+Ext.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import Foundation

extension String {
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    func isLessThan(_ num: Double) -> Bool {
        if !self.isNumeric {
            return false
        }
        guard let value = Double(self) else { return false}
        return value < num
    }
}
