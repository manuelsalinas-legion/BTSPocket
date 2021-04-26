//
//  ExperienceReal.swift
//  BTSPocket
//
//  Created by bts on 13/04/21.
//

import RealmSwift
import UIKit

class ExperienceRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var location: String?
    @objc dynamic var position: String?
    var responsibilities: List<String> = List<String>()
    @objc dynamic var company: String?
    @objc dynamic var fromDate: String?
    @objc dynamic var toDate: String?
    
    override class func primaryKey() -> String? {
        "company"
    }
}
