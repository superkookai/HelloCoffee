//
//  OrderCellView.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import SwiftUI

struct OrderCellView: View {
    let order: Order
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(order.name)
                    .accessibilityIdentifier("orderNameText")
                    .bold()
                Text("\(order.coffeeName), \(order.size.rawValue)")
                    .accessibilityIdentifier("coffeeNameAndSizeText")
                    .opacity(0.5)
            }
            
            Spacer()
            
            Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                .accessibilityIdentifier("coffeePriceText")
        }
    }
}

#Preview {
    OrderCellView(order: Order(name: "Joe", coffeeName: "Latte", total: 4, size: .large))
}
