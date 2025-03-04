//
//  AddCoffeeView.swift
//  HelloCoffee
//
//  Created by Weerawut Chaiyasomboon on 04/03/2568.
//

import SwiftUI

//MARK: - Error
struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
}

struct AddCoffeeView: View {
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    
    @EnvironmentObject private var model: CoffeeModel
    @Environment(\.dismiss) var dismiss
    
    @State private var errors = AddCoffeeErrors()
    
    private func clearFormErrors() {
        errors = AddCoffeeErrors()
    }
    
    //MARK: - Form Validation
    private func isFormValid() -> Bool {
        clearFormErrors()
        
        if name.isEmpty {
            errors.name = "Name is required"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee Name is required"
        }
        
        if price.isEmpty {
            errors.price = "Price is required"
        } else if !price.isNumeric {
            errors.price = "Price need to be a number"
        } else if price.isLessThan(1) {
            errors.price = "Price need to be more than zero"
        }
        
        return errors.name.isEmpty && errors.coffeeName.isEmpty && errors.price.isEmpty
    }
    
    //MARK: - View
    var body: some View {
        Text("Add Coffee Order")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
        
        Form {
            TextField("Name", text: $name)
                .accessibilityIdentifier("name")
                .onSubmit {
                    let _ = isFormValid()
                }
            
            Text(errors.name)
                .font(.caption)
                .foregroundStyle(.red)
                .visible(errors.name.isNotEmpty)
            
            
            TextField("Coffee Name", text: $coffeeName)
                .accessibilityIdentifier("coffeeName")
                .onSubmit {
                    let _ = isFormValid()
                }
            
            Text(errors.coffeeName)
                .font(.caption)
                .foregroundStyle(.red)
                .visible(errors.coffeeName.isNotEmpty)
            
            
            TextField("Price", text: $price)
                .accessibilityIdentifier("price")
                .onSubmit {
                    let _ = isFormValid()
                }
            
            Text(errors.price)
                .font(.caption)
                .foregroundStyle(.red)
                .visible(errors.price.isNotEmpty)
            
            
            Picker("Coffee Size", selection: $coffeeSize) {
                ForEach(CoffeeSize.allCases, id: \.self) { size in
                    Text(size.rawValue)
                        .tag(size)
                }
            }
            .pickerStyle(.segmented)
            
            Button {
                if isFormValid() {
                    //Place Order
                    Task {
                        let order = Order(name: name, coffeeName: coffeeName, total: Double(price)!, size: coffeeSize)
                        await model.placeOrder(order: order)
                        dismiss()
                    }
                }
            } label: {
                Text("Place Order")
                    .foregroundStyle(.black)
                    .padding(8)
                    .frame(maxWidth: .infinity)
                    .background(.green.opacity(0.7))
                    .clipShape(.rect(cornerRadius: 8))
            }
            .centerHorizontally()
            .accessibilityIdentifier("placeOrderButton")

        }
    }
}

#Preview {
    var config = Configuration()
    AddCoffeeView()
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: config.environment.baseURL)))
}
