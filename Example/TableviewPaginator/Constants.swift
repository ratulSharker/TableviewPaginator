//
//  Constants.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

struct Constants {

    static let tintColor = UIColor.init(red: 1.0, green: 78.0/255.0, blue: 32.0/255.0, alpha: 1.0)

    struct DOMAIN {
        static let reques = "https://reqres.in"
    }

    struct ROUTE {
        static let fetchUser = "/api/users?page=%d&per_page=%d"
    }

    static func fetchUser(page: Int, perPage: Int) -> String {
        let url = DOMAIN.reques + ROUTE.fetchUser
        return String.init(format: url, page, perPage)
    }
}
