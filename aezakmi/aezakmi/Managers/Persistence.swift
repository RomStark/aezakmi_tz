//
//  Persistence.swift
//  aezakmi
//
//  Created by Al Stark on 29.12.2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "aezakmi")
        container.loadPersistentStores { description, error in
            if (error as NSError?) != nil {
                print("error")
            }
        }
        context = container.viewContext
    }

    func fetchEntities<T: NSManagedObject>(ofType entityType: T.Type, sortDescriptors: [NSSortDescriptor]? = nil) async throws -> [T] {
        return try await context.perform {
            let request = NSFetchRequest<T>(entityName: String(describing: entityType))
            request.sortDescriptors = sortDescriptors
            return try context.fetch(request)
        }
    }

    func addPeripheralList(peripherals: [Peripheral]) async throws {
        try await context.perform {
            let newList = PeripheralListEntity(context: context)
            newList.date = Date()
            newList.count = Int16(peripherals.count)
            newList.uuid = UUID()
            
            let peripheralSet = peripherals.map { peripheral -> PeripheralEntity in
                let newPeripheral = PeripheralEntity(context: context)
                newPeripheral.name = peripheral.name
                newPeripheral.uuid = peripheral.id
                newPeripheral.rssi = Int16(peripheral.rssi)
                newPeripheral.status = peripheral.status
                return newPeripheral
            }
            
            newList.peripherals = NSSet(array: peripheralSet)
            
            try save()
        }
    }
    
    func save() throws {
        try context.save()
    }
}
