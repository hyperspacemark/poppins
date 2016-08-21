import Foundation
import CoreData
import Runes

class Store {
    fileprivate let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

    fileprivate var objectModel: NSManagedObjectModel? {
        let modelURL = Bundle.main.url(forResource: "PoppinsModel", withExtension: "momd")
        return modelURL >>- { NSManagedObjectModel(contentsOf: $0) }
    }

    var applicationDocumentDirectory: URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.last
    }

    init(storeType: String = NSSQLiteStoreType) {
        if let model = objectModel, let URL = applicationDocumentDirectory >>- appendSQLlitePathURL {
            managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator(storeType, model, URL)
        }
    }

    fileprivate func appendSQLlitePathURL(_ url: URL) -> URL? {
        return url.appendingPathComponent("PoppinsModel.sqlite")
    }

    fileprivate func persistentStoreCoordinator(_ storeType: String, _ objectModel: NSManagedObjectModel, _ storeURL: URL) -> NSPersistentStoreCoordinator {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: objectModel)
        let options = [
            NSInferMappingModelAutomaticallyOption: true,
            NSMigratePersistentStoresAutomaticallyOption: true
        ]

        _ = try? persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: .none, at: storeURL, options: options)

        return persistentStoreCoordinator
    }

    func newObject<A: NSManagedObject>(_ objectName: String) -> A? {
        let desc = NSEntityDescription.entity(forEntityName: objectName, in: managedObjectContext)
        return desc.map { A(entity: $0, insertInto: .none) }
    }

    func executeRequest<A: NSFetchRequestResult>(_ request: NSFetchRequest<A>) -> [A] {
        let results = try? managedObjectContext.fetch(request)
        return results ?? []
    }

    func insertObject<A: NSManagedObject>(_ object: A) {
        managedObjectContext.performAndWait {
            self.managedObjectContext.insert(object)
        }
    }

    func deleteObject<A: NSManagedObject>(_ object: A) {
        managedObjectContext.performAndWait {
            self.managedObjectContext.delete(object)
        }
    }

    func save() {
        managedObjectContext.performAndWait {
            do {
                try self.managedObjectContext.save()
            } catch {}
        }
    }

    var managedObjectContextObserver: ManagedObjectContextObserver {
        return ManagedObjectContextObserver(managedObjectContext: managedObjectContext)
    }
}
