//
//  AppEnvironment.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import Foundation

enum Endpoint {
    case allOrders
    case placeOrder
    case deleteOrder(Int)
    case updateOrder(Int)
    
    var path: String {
        switch self {
        case .allOrders:
            return "/test/orders"
        case .placeOrder:
            return "/test/new-order"
        case .deleteOrder(let orderId):
            return "/test/orders/\(orderId)"
        case .updateOrder(let orderId):
            return "/test/orders/\(orderId)"
        }
    }
}

enum AppEnvironment: String {
    case dev
    case test
    
    var baseURL: URL {
        switch self {
        case .dev:
            return URL(string: "https://island-bramble.glitch.me")!
        case .test:
            return URL(string: "https://island-bramble.glitch.me")!
        }
    }
}

struct Configuration {
    lazy var environment: AppEnvironment = {
        //Read value from Environment Variable
        guard let env = ProcessInfo.processInfo.environment["ENV"] else {
            return AppEnvironment.dev
        }
        if env == "TEST" {
            return AppEnvironment.test
        }
        return AppEnvironment.dev
    }()
}
