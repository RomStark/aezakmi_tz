//
//  ScanningListViewModel.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import Foundation

final class ScanningListViewModel: ObservableObject {
    @Published var coreDataManager: PersistenceController = .shared
    
    @Published var peripheralsList: [ScanningListModel] = []
    
    init() {
        fetchPeripheralsList()
    }

    private func fetchPeripheralsList() {
        Task {
            do {
                let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                let peripheralListEntities: [PeripheralListEntity] = try await self.coreDataManager.fetchEntities(
                    ofType: PeripheralListEntity.self,
                    sortDescriptors: [sortDescriptor]
                )
                await MainActor.run {
                    self.peripheralsList = peripheralListEntities.map { ScanningListModel(from: $0) }
                }
            } catch {
                print("Failed to fetch peripherals: \(error.localizedDescription)")
            }
        }
    }
}
