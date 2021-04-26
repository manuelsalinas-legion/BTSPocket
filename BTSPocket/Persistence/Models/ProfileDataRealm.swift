//
//  ProfileDataRealm.swift
//  BTSPocket
//
//  Created by bts on 13/04/21.
//

import RealmSwift
import UIKit

class ProfileDataRealm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var descriptionInfo: String?
    @objc dynamic var lastName: String?
    @objc dynamic var firstName: String?
    @objc dynamic var position: String?
    @objc dynamic var field: String?
    @objc dynamic var location: String?
    @objc dynamic var seniority: String?
    @objc dynamic var region: String?
    @objc dynamic var startDate: String?
    @objc dynamic var email: String?
    @objc dynamic var photo: String?
    var experiences: List<ExperienceRealm> = List<ExperienceRealm>()
    var skills: List<SkillRealm> = List<SkillRealm>()
    
    override class func primaryKey() -> String? {
        "email"
    }
    
    
}
