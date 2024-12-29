//
//  PeripheralInfoView.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import SwiftUI

struct PeripheralInfoView: View {
    var peripheral: Peripheral
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Name: \(peripheral.name)")
                .font(.headline)
            
            Text("ID: \(peripheral.id)")
                .font(.subheadline)
            
            Text("RSSI: \(peripheral.rssi)")
                .font(.subheadline)
            
            Text("Status: \(peripheral.status)")
                .foregroundColor( peripheral.status == "Disconnected" ? .red : .green )
                .font(.subheadline)
        }
    }
}

#Preview {
    PeripheralInfoView(peripheral: Peripheral(id: UUID(uuidString: "f41c6e7d-2583-40a9-b6f3-9970d6515f60")!, name: "telephone", rssi: -33, status: "connected"))
}
