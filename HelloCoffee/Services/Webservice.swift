//
//  Webservice.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case badResponse
    case decodedError
}

class Webservice {
    private var baseURL: URL
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func getOrders() async throws -> [Order] {
        guard let url = URL(string: Endpoint.allOrders.path, relativeTo: baseURL) else {
            throw NetworkError.badURL
        }
        
        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let orders = try? JSONDecoder().decode([Order].self, from: data) else {
            throw NetworkError.decodedError
        }
        
        return orders
    }
    
    func placeOrder(order: Order) async throws -> Order {
        guard let url = URL(string: Endpoint.placeOrder.path, relativeTo: baseURL) else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let newOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodedError
        }
        
        return newOrder
    }
    
    func deleteOrder(orderId: Int) async throws -> Order {
        guard let url = URL(string: Endpoint.deleteOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let deleteOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodedError
        }
        
        return deleteOrder
    }
    
    func updateOrder(_ order: Order) async throws -> Order {
        guard let orderId = order.id else {
            throw NetworkError.badRequest
        }
        
        guard let url = URL(string: Endpoint.updateOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        guard let updateOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodedError
        }
        
        return updateOrder
    }
}
