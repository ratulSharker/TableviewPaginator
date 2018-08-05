//
//  APIClient.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Alamofire

class APIClient {

    static func fetchUser(page: Int, perPage: Int, completion: @escaping (DataResponse<Any>) -> Void) {

        Alamofire.request(Constants.fetchUser(page: page, perPage: perPage),
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil).responseJSON(completionHandler: completion)
    }

}
