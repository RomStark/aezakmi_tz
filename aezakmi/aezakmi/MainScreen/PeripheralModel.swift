//
//  PeripheralModel.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import Foundation

struct Peripheral: Identifiable {
    let id: UUID
    let name: String
    let rssi: Int
    let status: String
}

extension Peripheral {
    init(from entity: PeripheralEntity) {
        self.id = entity.uuid ?? UUID()
        self.name = entity.name ?? "Unknown"
        self.rssi = Int(entity.rssi)
        self.status = entity.status ?? ""
    }
}
