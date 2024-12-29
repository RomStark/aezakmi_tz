//
//  BLEManager.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var central: CBCentralManager!
    
    @Published var peripherals: [Peripheral] = []
    @Published var isSwitchedOn: Bool = false
    
    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        isSwitchedOn = central.state == .poweredOn
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        var status = ""
        switch peripheral.state {
        case .connected:
            status = "Connected"
        case .connecting:
            status = "Connecting"
        case .disconnected:
            status = "Disconnected"
        case .disconnecting:
            status = "Disconnecting"
        @unknown default:
            status = "unknown"
        }
        
        let newPeripheral = Peripheral(
            id: peripheral.identifier,
            name: peripheral.name ?? "Unknown",
            rssi: RSSI.intValue,
            status: status
        )
        
        let lock = NSLock()
        
        DispatchQueue.main.async {
            lock.lock()
            self.peripherals.removeAll { $0.id == newPeripheral.id }
            self.peripherals.append (newPeripheral)
            lock.unlock()
        }
    }
    
    func startScanning() {
        peripherals = []
        central.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        central.stopScan()
    }
}
