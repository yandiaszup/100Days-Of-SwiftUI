//
//  ContentView.swift
//  TempConverter-Day19
//
//  Created by Yan Lucas on 12/08/20.
//  Copyright © 2020 Yan Lucas. All rights reserved.
//

import SwiftUI

enum TemperatureUnit: String {
    case Celsius = "Celsius"
    case Fahrenheit = "Fahrenheit"
    case Kelvin = "Kelvim"
    
    func convert(to unit: TemperatureUnit, temp: Double) -> Double {
        let firstTemp = Measurement(value: temp, unit: self.toUnitTemperature())
        let convertedTemp = firstTemp.converted(to: unit.toUnitTemperature())
        return convertedTemp.value
    }
    
    private func toUnitTemperature() -> UnitTemperature {
        switch self {
        case .Celsius:
            return UnitTemperature.celsius
        case .Fahrenheit:
            return UnitTemperature.fahrenheit
        case .Kelvin:
            return UnitTemperature.kelvin
        }
    }
}

struct ContentView: View {
    
    @State private var firstUnit = 0
    @State private var secondUnit = 1
    @State private var temperature = ""
    
    private var convertedTemperature: Double {
        let firstUnitType = units[firstUnit]
        let secondUnitType = units[secondUnit]
        guard let temperature = Double(temperature) else { return 0 }
        
        let convertedTemperature = firstUnitType.convert(to: secondUnitType, temp: temperature)
        return convertedTemperature
    }
    
    private let units: [TemperatureUnit] = [.Celsius, .Fahrenheit, .Kelvin]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("From")) {
                    TextField("Temperature", text: $temperature)
                        .keyboardType(.decimalPad)
                    
                    buildSegmentedPicker(binding: $firstUnit, label: "From")
                }
                
                Section(header: Text("To")) {
                    buildSegmentedPicker(binding: $secondUnit, label: "To")
                    
                    Text("\(convertedTemperature, specifier: "%.2f") \(units[secondUnit].rawValue)").customModifier()
                }
                
            }.navigationBarTitle("Temp Converter")
        }
    }
    
    func buildSegmentedPicker(binding: Binding<Int>, label: String) -> some View {
        let picker = Picker(selection: binding, label: Text(label)) {
            ForEach(0 ..< units.count) {
                Text("\(self.units[$0].rawValue)")
            }
        }.pickerStyle(SegmentedPickerStyle())
        
        return picker
    }
}

struct CustomModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.foregroundColor(Color.red)
        .padding()
            .background(Color.red)
    }
}

extension View {
    func customModifier() -> some View {
        self.modifier(CustomModifier())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
