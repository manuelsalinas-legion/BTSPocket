//
//  RealmAPI.swift
//
//

import Foundation
import RealmSwift

class RealmAPI {
    private var realm: Realm
    static let shared = RealmAPI()

    private init() {
        realm = try! Realm()
    }

    // MARK: WRITE
    ///Write a Realm entity with Default configuration
    func write(_ entity: Object) {
        print("Realm DB is located at:", realm.configuration.fileURL!)

        do {
            try realm.write {
                realm.add(entity, update: .all)
            }
        } catch {
            print("Realm | Error | Write Object: \(error.localizedDescription)")
        }
    }

    ///Write a Realm entity collection with Default configuration
    func write(_ entities: [Object]) {
        print("Realm DB is located at:", realm.configuration.fileURL!)

        do {
            try realm.write {
                realm.add(entities, update: .all)
            }
        } catch {
            print("Realm | Error | Write Array Object: \(error.localizedDescription)")
        }
    }

    // MARK: WRITE W/ COMPLETION HANDLER
    ///Write a Realm entity with completion handler
    func write(_ entity: Object, completion: () -> Void) {
        print("Realm DB is located at:", realm.configuration.fileURL!)

        do {
            try realm.write(transaction: {
                realm.add(entity, update: .all)
            }, completion: {
                completion()
            })
        } catch {
            print("Realm | Error | Write Object: \(error.localizedDescription)")
        }
    }

    ///Write a Realm entity collection with completion handler
    func write(_ entities: [Object], completion: () -> Void) {
        print("Realm DB is located at:", realm.configuration.fileURL!)

        do {
            try realm.write(transaction: {
                realm.add(entities, update: .all)
            }, completion: {
                completion()
            })
        } catch {
            print("Realm | Error | Write Object: \(error.localizedDescription)")
        }
    }

    // MARK: DELETE
    ///Delete a Realm entity with Default configuration
    func delete(_ entity: Object) {
        do {
            try realm.write {
                realm.delete(entity)
            }
        } catch {
            print("Realm | Error | Delete Object: \(error.localizedDescription)")
        }
    }

    //Delete a Realm entity collection with Default configuration
    func delete(_ entities: [Object]) {
        print("Realm: Deleted collection action")
        do {
            try realm.write {
                realm.delete(entities)
            }
        } catch {
            print("Realm | Error | Delete Array Object: \(error.localizedDescription)")
        }
    }

    ///Delete everything Realm entities with Default configuration
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Realm | Error | Delete All: \(error.localizedDescription)")
        }
    }

    // MARK: QUERY
    /**
     This funciton returns all kind of objects given
     
     - Parameters:
     
     - className: Class name / type  to find ("select * from")
     - predicate: Query for Data Base, If It's nil won't make filter
     */
    ///Returns: An array of given type
    func select(className type: AnyClass, predicate query: NSPredicate?) -> [Object] {
        let objectType = type as? Object.Type
        let queryResults = query != nil ? realm.objects(objectType!).filter(query!) : realm.objects(objectType!)
        let results = Array(queryResults)

        return results
    }

    // MARK: BACKUP
    func createRealmBackup(path url: URL) {
        print("Creating Realm DB backup...")

        do {
            try realm.writeCopy(toFile: url)
            print("Realm | Realm DB backup file created in \(url.absoluteString)")
        } catch {
            print("Realm | Error | Creating Realm DB Backup: \(error.localizedDescription)")
        }
    }
}

// MARK: REALM EXTENSION
extension Realm {
    /// Performs actions contained within the given block
    /// inside a write transaction with completion block.
    ///
    /// - parameter block: write transaction block
    /// - parameter completion: completion executed after transaction block
    func write(transaction block: () -> Void, completion: () -> Void) throws {
        try write(block)
        completion()
    }
}
