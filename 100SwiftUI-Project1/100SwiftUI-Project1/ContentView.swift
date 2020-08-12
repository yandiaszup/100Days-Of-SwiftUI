//
//  ContentView.swift
//  100SwiftUI-Project1
//
//  Created by Yan Lucas on 10/08/20.
//  Copyright © 2020 Yan Lucas. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkoutAmount = ""
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalAmount: Double {
        let tipSelected: Double = Double(tipPercentages[tipPercentage])
        guard let orderAmount = Double(checkoutAmount) else { return 0 }
        
        let tipValue = orderAmount / 100 * tipSelected
        let grandTotal = orderAmount + tipValue
        return grandTotal
    }
    
    var totalPerPerson: Double {
        guard let peopleCount: Double = Double(numberOfPeople) else { return 0 }
        let amountPerPerson = totalAmount / peopleCount
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkoutAmount)
                        .keyboardType(.decimalPad)
                    TextField("Number of people", text: $numberOfPeople).keyboardType(.numberPad)
                }
                
                
                Section(header: Text("How much tip do you want do leave?")) {
                    Picker("Tip Percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total Amount")) {
                    Text("$\(totalAmount, specifier: "%.2f")")
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
