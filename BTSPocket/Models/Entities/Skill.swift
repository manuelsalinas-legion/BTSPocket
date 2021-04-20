//
//  Skill.swift
//  BTSPocket
//
//  Created by bts on 30/03/21.
//

import Foundation
import RealmSwift

struct Skill: Codable {
    var id: Int?
    var skill: String?
    var levelId: Int?
}

extension Skill: Persistable {
    init(realmObject: SkillRealm) {
        self.id = realmObject.id
        self.skill = realmObject.skill
        self.levelId = realmObject.levelId
    }
    
    func persistenceObject() -> SkillRealm {
        let object = SkillRealm()
        object.id = self.id ?? 0
        object.skill = self.skill
        object.levelId = self.levelId ?? 0
        
        return object
    }
}


