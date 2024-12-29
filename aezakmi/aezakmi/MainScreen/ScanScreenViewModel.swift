//
//  ScanScreenViewModel.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import Foundation

struct CustomError: Equatable {
    var message: String
    var title: String
}

final class ScanViewModel: ObservableObject {
    @Published private var coreDataManager: PersistenceController = .shared
    @Published private var bluetoothManager: BLEManager = .init()
    @Published var peripherals: [Peripheral] = []
    @Published var isSwitchedOn: Bool = false
    @Published var isScanning = false
    @Published var errorMessage: CustomError?
    
    private var scanningTimer: DispatchWorkItem?
    
    init() {
        bluetoothManager.$peripherals
            .assign(to: &$peripherals)
        bluetoothManager.$isSwitchedOn
            .assign(to: &$isSwitchedOn)
    }
    
    func startScanning() {
        if isSwitchedOn {
            isScanning = true
            
            bluetoothManager.startScanning()
            
            scanningTimer?.cancel()
            let timer = DispatchWorkItem { [weak self] in
                Task {
                    await self?.stopScanning()
                }
            }
            scanningTimer = timer
            DispatchQueue.main.asyncAfter(deadline: .now() + 20, execute: timer)
        } else {
            errorMessage = CustomError(
                message: "Включите bluetooth",
                title: "Ошибка"
            )
        }
    }
    
    @MainActor
    func stopScanning() async {
        scanningTimer?.cancel()
        bluetoothManager.stopScanning()
        isScanning = false
        do {
            try await addNewList()
            errorMessage = CustomError(
                message: "Найдено \(peripherals.count) устройств.",
                title: "Сканирование завершено"
            )
        } catch {
            errorMessage = CustomError(
                message: "Не удалось сохранить данные: \(error.localizedDescription)",
                title: "Ошибка"
            )
        }
    }
    
    private func addNewList() async throws {
        try await coreDataManager.addPeripheralList(peripherals: peripherals)
    }
}

