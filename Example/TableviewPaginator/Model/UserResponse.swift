//
//  UserResponse.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

class UserResponse: Decodable {
    var page: Int
    var perPage: Int
    var total: Int
    var data: [User]

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case total = "total"
        case data = "data"
    }

    required init(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        page = try container.decode(Int.self, forKey: .page)
        perPage = try container.decode(Int.self, forKey: .perPage)
        total = try container.decode(Int.self, forKey: .total)
        data = try container.decode([User].self, forKey: .data)
    }
}
