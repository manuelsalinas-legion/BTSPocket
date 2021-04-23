//
//  ProfileData.swift
//  BTSPocket
//
//  Created by bts on 27/03/21.
//

import Foundation
import RealmSwift

struct ProfileData: Codable {
    var id: Int?
    var description: String?
    var lastName: String?
    var firstName: String?
    var position: String?
    var field: String?
    var location: String?
    var seniority: String?
    var region: String?
    var startDate: String?
    var email: String?
    var photo: String?
    var experiences: [Experience]?
    var skills: [Skill]?
    
    var fullName: String {
        let full = (firstName ?? String()) + " " + (lastName ?? String())
        return full.trim().isEmpty ? "Uknown" : full.capitalized
    }
}

extension ProfileData: Persistable {
    init(realmObject: ProfileDataRealm) {
        self.id = realmObject.id
        self.description = realmObject.descriptionInfo
        self.firstName = realmObject.firstName
        self.lastName = realmObject.lastName
        self.position = realmObject.position
        self.field = realmObject.field
        self.location = realmObject.location
        self.seniority = realmObject.seniority
        self.region = realmObject.region
        self.startDate = realmObject.startDate
        self.email = realmObject.email
        self.photo = realmObject.photo
        
        var experiences = [Experience]()
        realmObject.experiences.forEach({ experiences.append(Experience(realmObject: $0)) })
        self.experiences = experiences
        
        var skills = [Skill]()
        realmObject.skills.forEach({ skills.append( Skill(realmObject: $0) ) })
        self.skills = skills
    }
    func persistenceObject() -> ProfileDataRealm {
        let object = ProfileDataRealm()
        object.id = self.id ?? 0
        object.descriptionInfo = self.description
        object.firstName = self.firstName
        object.lastName = self.lastName
        object.position = self.position
        object.field = self.field
        object.location = self.location
        object.seniority = self.seniority
        object.region = self.region
        object.startDate = self.startDate
        object.email = self.email
        object.photo = self.photo
        
        let experiences = List<ExperienceRealm>()
        self.experiences?.forEach({ experiences.append($0.persistenceObject()) })
        object.experiences = experiences
        
        let skills = List<SkillRealm>()
        self.skills?.forEach({ skills.append( ($0.persistenceObject()) ) })
        object.skills = skills
        
        return object
    }
}
