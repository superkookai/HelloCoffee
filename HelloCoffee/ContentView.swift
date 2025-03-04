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
    
    var body: some View {
        NavigationStack {
            VStack {
                if model.orders.isEmpty {
                    Text("No orders available!")
                        .accessibilityIdentifier("noOrdersText")
                } else {
                    List(model.orders) { order in
                        OrderCellView(order: order)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Orders")
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
                AddCoffeeView()
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

