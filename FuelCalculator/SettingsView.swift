//
//  SettingsView.swift
//  FuelCalculator
//
//  Created by Emre Ilhan on 26.07.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @AppStorage("showCarbonDioxide") var showCarbonDioxide = true
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("General")) {
                    Toggle(isOn: $showCarbonDioxide) {
                        Text("Show Carbon Dioxide")
                    }
                }

            }
            .navigationTitle("Settings")
            .toolbar{
                //toolbaritem in order to dismiss view
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Dismiss", systemImage: "xmark.circle.fill")
                            
                    }.foregroundStyle(.gray).buttonStyle(.plain)

                }
            }
        }
        
    }
}
#Preview {
    SettingsView()
}

