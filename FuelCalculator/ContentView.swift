//
//  ContentView.swift
//  FuelCalculator
//
//  Created by Emre Ilhan on 23.07.2024.
//

import SwiftUI
import SwiftData

extension UIApplication {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
    
    
    @State private var fuelPrice: String = ""
    @State private var kilometer: String = ""
    @State private var fuelUsageAt100km: String = ""
    @State private var numberOfPassangers: String = ""
    @State private var totalCost: Double = 0
    @State private var costPerPerson: Double = 0
    @State private var carbonFootprint: Double = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section{
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "dollarsign")
                                    Text("Price per liter")
                                }
                                .font(.headline)
                                TextField("Price", text: $fuelPrice)
                                    .modifier(TextFieldModifier())
                                    .keyboardType(.decimalPad)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Kilometers")
                                    Image(systemName: "road.lanes")
                                }
                                .font(.headline)
                                TextField("Kilometers", text: $kilometer)
                                    .modifier(TextFieldModifier())
                                    .keyboardType(.decimalPad)
                            }
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "gauge.open.with.lines.needle.67percent.and.arrowtriangle.and.car")
                                    Text("Fuel usage per 100 km")
                                        .font(.headline)
                                }
                                TextField("(l/100km)", text: $fuelUsageAt100km)
                                    .modifier(TextFieldModifier())
                                    .keyboardType(.decimalPad)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Number of Passengers")
                                        .font(.headline)
                                    Image(systemName: "person.3.fill")
                                }
                                TextField("1..3 etc.", text: $numberOfPassangers)
                                    .modifier(TextFieldModifier())
                                    .keyboardType(.decimalPad)
                            }
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Total Cost:")
                                    .font(.headline)
                                Text(totalCost, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Cost per Person:")
                                    .font(.headline)
                                Text(costPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .bold()
                            }
                        }
                            VStack(alignment: .leading) {
                                HStack{
                                Text("Carbon Footprint:")
                                    .font(.headline)
                                    Text(carbonFootprint, format: .number)
                                    Text("kg CO2")
                                        .fontWeight(.light)
                                }
                                .foregroundStyle(.red)
                                .padding(7)
                                .frame(maxWidth: .infinity)
                                .background(.red.opacity(0.2))
                                .clipShape(.rect(cornerRadius: 12))
                                
                            }
                            Button {
                                UIApplication.shared.endEditing()  // Dismiss the keyboard
                                calculateCosts()
                            } label: {
                                Text("Calculate")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .background(.green)
                                    .clipShape(.rect(cornerRadius: 13))
                            }
                            
                                           
                    } footer: {
                        Text("This calculator helps you estimate the total fuel cost for your trip, how much each passenger should contribute, and the carbon footprint of your journey.")
                        
                    }
                    
                }
            }
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Fuel Calculator")
            .toolbar{
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        UIApplication.shared.endEditing()
                    }.tint(.gray)
                }
            }
        }
    }
    
    private func calculateCosts() {
        // Helper function to replace commas with periods
        func convertCommaToPeriod(_ value: String) -> String {
            return value.replacingOccurrences(of: ",", with: ".")
        }
        
        // Convert commas to periods
        let processedFuelPrice = convertCommaToPeriod(fuelPrice)
        let processedKilometer = convertCommaToPeriod(kilometer)
        let processedFuelUsageAt100km = convertCommaToPeriod(fuelUsageAt100km)
        let processedNumberOfPassengers = convertCommaToPeriod(numberOfPassangers)
        
        guard let fuelPrice = Double(processedFuelPrice),
              let kilometer = Double(processedKilometer),
              let fuelUsageAt100km = Double(processedFuelUsageAt100km),
              let numberOfPassangers = Double(processedNumberOfPassengers) else {
            alertMessage = "Please enter valid numbers for all fields."
            showAlert = true
            return
        }
        
        guard fuelPrice > 0, kilometer > 0, fuelUsageAt100km > 0, numberOfPassangers > 0 else {
            alertMessage = "All values must be greater than zero."
            showAlert = true
            return
        }
        
        let usageAmountOfFuelAtOneKilometer = fuelUsageAt100km / 100
        totalCost = usageAmountOfFuelAtOneKilometer * fuelPrice * kilometer
        costPerPerson = totalCost / numberOfPassangers
        
        let co2PerLiter = 2.31 // kg CO2 per liter of gasoline
        carbonFootprint = usageAmountOfFuelAtOneKilometer * co2PerLiter * kilometer
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(7)
            .background(.gray.opacity(0.1))
            .clipShape(.rect(cornerRadius: 12))
    }
}

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundStyle(.primary)
                configuration.label
            }
        })
    }
}

#Preview {
    ContentView()
}
