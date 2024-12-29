//
//  ScanScreenView.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import SwiftUI
import Lottie

struct ScanView: View {
    @StateObject var vm: ScanViewModel = .init()
    @State private var showAlert = false

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Bluetooth Devices")
                    .font (.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                
                List(vm.peripherals) { peripheral in
                    NavigationLink(destination: PeripheralInfoView(peripheral: peripheral)) {
                        PeripheralCell(peripheral: peripheral)
                    }
                }
                
                LottieView(animation: .named("BluetoothAnimation.json"))
                    .configure({ view in
                        view.contentMode = .scaleAspectFill
                  })
                    .playbackMode(
                        .playing(
                            .toProgress(
                                vm.isScanning ? 1 : 0.5,
                                loopMode: vm.isScanning ? .autoReverse : .playOnce
                            )
                        )
                    )
                    .frame(width: 50, height: 50)

                Text(vm.isSwitchedOn ? "Bluetooth on" : "Bluetooth off")
                    .foregroundColor(vm.isSwitchedOn ? .green : .red)
                
                
                Button(action: {
                    Task {
                        if vm.isScanning {
                            await vm.stopScanning()
                        } else {
                            vm.startScanning()
                        }
                    }
                }) {
                    Text(vm.isScanning ? "Stop Scanning" : "Start Scanning")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                

                Spacer()
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: ScanningListView()) {
                        Image(systemName: "list.bullet")
                            .imageScale(.large)
                    }
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(vm.errorMessage?.title ?? "Ошибка"),
                    message: Text(vm.errorMessage?.message ?? "Неизвестная ошибка"),
                    dismissButton: .default(Text("Ok"), action: {
                        vm.errorMessage = nil
                    })
                )
            }
            .onChange(of: vm.errorMessage) { errorMessage in
                if errorMessage != nil {
                    showAlert = true
                }
            }
        }
    }
}

struct PeripheralCell: View {
    var peripheral: Peripheral
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(peripheral.name)
                Spacer()
                Text(String(peripheral.rssi))
                Text(peripheral.status)
            }
            Text("UUID: \(peripheral.id.uuidString)")
                .font(.system(size: 12))
        }
    }
}

#Preview {
    ScanView()
}
