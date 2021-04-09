//
//  Persistable.swift
//

import Foundation
import RealmSwift

public protocol Persistable {
    associatedtype RealmObject: RealmSwift.Object
    init(realmObject: RealmObject)
    func persistenceObject() -> RealmObject
}
