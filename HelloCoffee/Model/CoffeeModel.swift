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
    
    func deleteOrder(orderId: Int) async {
        do {
            let deleteOrder = try await webservice.deleteOrder(orderId: orderId)
            self.orders = self.orders.filter({$0.id != deleteOrder.id})
        } catch {
            fatalError("ERROR delete order: \(error.localizedDescription)")
        }
    }
    
    func updateOrder(_ order: Order) async {
        do {
            let updateOrder = try await webservice.updateOrder(order)
            guard let index = self.orders.firstIndex(where: {$0.id == updateOrder.id}) else {
                fatalError("Error getting update order id")
            }
            self.orders[index] = updateOrder
        } catch {
            fatalError("Error updating order: \(error.localizedDescription)")
        }
    }
    
    func orderById(_ id: Int) -> Order? {
        guard let index = self.orders.firstIndex(where: {$0.id == id}) else {
            return nil
        }
        return self.orders[index]
    }
}
