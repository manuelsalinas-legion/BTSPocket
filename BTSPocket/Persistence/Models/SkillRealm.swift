//
//  SkillRealm.swift
//  BTSPocket
//
//  Created by bts on 14/04/21.
//

import RealmSwift

class SkillRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var skill: String?
    @objc dynamic var levelId: Int = 1
    
    @objc dynamic var pk: String? {
        "\(String(describing: skill))-\(levelId)"
    }
    
    // just return the name of the property
    override class func primaryKey() -> String? {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["skill"]
    }
}
