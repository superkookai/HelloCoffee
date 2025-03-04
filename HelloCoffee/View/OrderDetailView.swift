//
//  OrderDetailView.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import SwiftUI

struct OrderDetailView: View {
    let orderId: Int
    @EnvironmentObject private var model: CoffeeModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showEditOrder: Bool = false
    
    private func deleteOrder() async {
        await model.deleteOrder(orderId: self.orderId)
        dismiss()
    }
    
    var body: some View {
        VStack {
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                    
                    Text(order.size.rawValue)
                        .opacity(0.5)
                    
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    
                    HStack {
                        Button(role: .destructive) {
                            Task {
                                await deleteOrder()
                            }
                        } label: {
                            Text("Delete Order")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .accessibilityIdentifier("deleteOrderButton")
                        
                        
                        Button {
                            showEditOrder = true
                        } label: {
                            Text("Edit Order")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                        .accessibilityIdentifier("editOrderButton")
                        
                    }
                    
                    Spacer()
                }
                .sheet(isPresented: $showEditOrder) {
                    AddEditCoffeeView(order: order)
                }
            } else {
                Text("No Order with \(orderId) id.")
            }
        }
        .padding()
    }
}

#Preview {
    var config = Configuration()
    OrderDetailView(orderId: 1)
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: config.environment.baseURL)))
}
