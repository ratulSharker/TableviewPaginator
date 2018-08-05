//
//  User.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class User: Decodable {
    var userId: Int
    var firstName: String
    var lastName: String
    var avatar: String

    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "avatar"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(Int.self, forKey: .userId)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        avatar = try container.decode(String.self, forKey: .avatar)
    }
}
