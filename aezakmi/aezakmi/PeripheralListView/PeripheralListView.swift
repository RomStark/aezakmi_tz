//
//  PeripheralListView.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import SwiftUI

struct PeripheralListView: View {
    var peripheralList: [Peripheral]
    var body: some View {
        VStack {
            Text("Peripherals List")
            List(peripheralList) { item in
                NavigationLink(destination: PeripheralInfoView(peripheral: item)) {
                    PeripheralCell(peripheral: item)
                }
            }
        }
    }
}


#Preview {
    PeripheralListView(peripheralList: [])
}
