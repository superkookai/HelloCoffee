//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: CoffeeModel
    @State private var showAddOrderView: Bool = false
    
    private func deleteOrder(orderId: Int) {
        Task {
            await model.deleteOrder(orderId: orderId)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!")
                        .accessibilityIdentifier("noOrdersText")
                } else {
                    List(model.orders) { order in
                        NavigationLink(value: order.id) {
                            OrderCellView(order: order)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        deleteOrder(orderId: order.id!)
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    .accessibilityIdentifier("Delete")
                                }
                        }
                    }
                    .accessibilityIdentifier("orderList")
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Int.self, destination: { orderId in
                OrderDetailView(orderId: orderId)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddOrderView.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .tint(.black)
                    .accessibilityIdentifier("addNewOrderButton")
                }
            }
            .sheet(isPresented: $showAddOrderView) {
                AddEditCoffeeView()
            }
        }
        .task {
            await model.populateOrders()
        }
    }
}

#Preview {
    var config = Configuration()
    ContentView()
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: config.environment.baseURL)))
}

