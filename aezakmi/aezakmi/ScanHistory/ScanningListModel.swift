//
//  ScanningListModel.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import Foundation

struct ScanningListModel: Identifiable {
    var id: UUID
    
    var date: Date
    var count: Int
    var peripherals: [Peripheral]
}

extension ScanningListModel {
    init(from entity: PeripheralListEntity) {
        self.id = entity.uuid ?? UUID()
        self.count = Int(entity.count)
        self.date = entity.date ?? Date()
        self.peripherals = (entity.peripherals?.allObjects as? [PeripheralEntity])?.map { Peripheral(from: $0) } ?? []
    }
}
