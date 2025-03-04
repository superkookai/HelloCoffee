//
//  AddEditCoffeeView.swift
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

struct AddEditCoffeeView: View {
    var order: Order? = nil
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
    
    //MARK: - Form Validation and Functions
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
    
    private func populateOrderToEdit() {
        if let orderToEdit = self.order {
            self.name = orderToEdit.name
            self.coffeeName = orderToEdit.coffeeName
            self.price = String(orderToEdit.total)
            self.coffeeSize = orderToEdit.size
        }
    }
    
    private func saveOrUpdate() async {
        if let order {
            var editOrder = order
            editOrder.name = self.name
            editOrder.coffeeName = self.coffeeName
            editOrder.total = Double(self.price)!
            editOrder.size = self.coffeeSize
            await model.updateOrder(editOrder)
        } else {
            let order = Order(name: name, coffeeName: coffeeName, total: Double(price)!, size: coffeeSize)
            await model.placeOrder(order: order)
        }
        dismiss()
    }
    
    var hasOrderToEdit: Bool {
        self.order != nil
    }
    
    //MARK: - View
    var body: some View {
        VStack {
            Text(hasOrderToEdit ? "Edit Coffee Order" : "Add Coffee Order")
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
                        //Place or Edit Order
                        Task {
                            await saveOrUpdate()
                        }
                    }
                } label: {
                    Text(hasOrderToEdit ? "Update Order" : "Place Order")
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
        .onAppear {
            populateOrderToEdit()
        }
    }
}

#Preview {
    var config = Configuration()
    AddEditCoffeeView()
        .environmentObject(CoffeeModel(webservice: Webservice(baseURL: config.environment.baseURL)))
}
