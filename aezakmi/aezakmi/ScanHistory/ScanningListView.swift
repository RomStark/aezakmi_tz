//
//  ScanningListView.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import SwiftUI

struct ScanningListCell: View {
    var scanningList: ScanningListModel
    var body: some View {
        HStack {
            Text("time: \(scanningList.date, formatter: itemFormatter)")
            Spacer()
            Text(String("count: \(scanningList.count)"))
        }
    }
}

struct ScanningListView: View {
    
    @StateObject var vm: ScanningListViewModel = .init()
    var body: some View {
        VStack{
            Text("Scanning List")
            List(vm.peripheralsList) { item in
                NavigationLink(destination: PeripheralListView(peripheralList: item.peripherals)) {
                    ScanningListCell(scanningList: item)
                }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()


#Preview {
    ScanningListView()
}
