//
//  Experience.swift
//  BTSPocket
//
//  Created by bts on 30/03/21.
//

import Foundation
import RealmSwift

struct Experience: Codable {
    var id: Int?
    var location: String?
    var position: String?
    var responsibilities: [String]?
    var company: String?
    var fromDate: String?
    var toDate: String?
}

extension Experience: Persistable {
    init(realmObject: ExperienceRealm) {
        self.id = realmObject.id
        self.location = realmObject.location
        self.position = realmObject.position
        self.company = realmObject.company
        self.fromDate = realmObject.fromDate
        self.toDate = realmObject.toDate
        
        var responsabilities = [String]()
        realmObject.responsibilities.forEach({ responsabilities.append($0) })
        self.responsibilities = responsabilities
    }
    
    func persistenceObject() -> ExperienceRealm {
        let object = ExperienceRealm()
        object.id = self.id ?? 0
        object.location = self.location
        object.position = self.position
        object.company = self.company
        object.fromDate = self.fromDate
        object.toDate = self.toDate
        
        let responsabilities = List<String>()
        self.responsibilities?.forEach({ responsabilities.append($0) })
        object.responsibilities = responsabilities
        
        return object
    }
}
