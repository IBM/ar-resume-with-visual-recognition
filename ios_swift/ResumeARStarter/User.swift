//
//  User.swift
//  ResumeARStarter
//
//  Created by Sanjeev Ghimire on 4/15/19.
//  Copyright © 2019 Sanjeev Ghimire. All rights reserved.
//

import Foundation


struct User: Codable {
    var classificationId: String!
    var name: String!
    var twitter: String!
    var facebook: String!
    var linkedin: String!
    var location: String!
    var phone: String!
}


enum UserLoadError: Error {
    case noConfigFile
    case incorrectlyFormattedFile
}

class UserLoad {
    static func load() throws -> [String:User] {
        guard let path = Bundle.main.path(forResource: "UserInfo", ofType: "json") else {
            throw UserLoadError.noConfigFile
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoded = try JSONDecoder().decode([User].self, from: data)
            var userMap:[String:User] = [:]
            for user in decoded {
                userMap[user.classificationId] = user
            }
            return userMap
        } catch let error{
            print("parse error: \(error.localizedDescription)")
            throw UserLoadError.incorrectlyFormattedFile
        }
    }
}
