import Foundation
import CoreData

class ManagedObjectContextObserver {
    var callback: (([CachedImage], [CachedImage], [CachedImage]) -> ())? = .none

    init(managedObjectContext: NSManagedObjectContext) {
        NotificationCenter.default.addObserver(self, selector: #selector(ManagedObjectContextObserver.contextDidChange(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: managedObjectContext)
    }

    @objc func contextDidChange(_ notification: Notification) {
        let insertsSet = (notification as NSNotification).userInfo?[NSInsertedObjectsKey] as? NSSet
        let inserts = insertsSet?.allObjects as? [CachedImage] ?? []

        let updatesSet = (notification as NSNotification).userInfo?[NSUpdatedObjectsKey] as? NSSet
        let updates = updatesSet?.allObjects as? [CachedImage] ?? []

        let deletesSet = (notification as NSNotification).userInfo?[NSDeletedObjectsKey] as? NSSet
        let deletes = deletesSet?.allObjects as? [CachedImage] ?? []

        callback?(inserts, updates, deletes)
    }
}
