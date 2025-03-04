//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import Foundation

@MainActor
class CoffeeModel: ObservableObject {
    let webservice: Webservice
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    @Published private(set) var orders: [Order] = []
    
    func populateOrders() async {
        do {
            self.orders = try await webservice.getOrders()
        } catch {
            fatalError("Error getting Orders: \(error.localizedDescription)")
        }
    }
    
    func placeOrder(order: Order) async {
        do {
            let newOrder = try await webservice.placeOrder(order: order)
            orders.append(newOrder) //This line is need???
        } catch {
            fatalError("Error placing order: \(error.localizedDescription)")
        }
    }
}
