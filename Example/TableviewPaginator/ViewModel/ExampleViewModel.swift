//
//  ExampleViewModel.swift
//  TableviewPaginator_Example
//
//  Created by ratul sharker on 8/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

protocol ExampleViewModelProtocol: class {
    func userFetched(success: Bool, userCount: Int)
}

class ExampleViewModel {
    private weak var delegate: ExampleViewModelProtocol?
    private var users: [User] = [User]()

    init(delegate: ExampleViewModelProtocol) {
        self.delegate = delegate
    }

    func numberOfRows() -> Int {
        return users.count
    }

    func getUser(at index: Int) -> User? {
        guard index < users.count else {
            return nil
        }
        return users[index]
    }

    func fetchUsers(offset: Int, limit: Int, shouldAppend: Bool) {
        let page = offset / limit
        print("page: \(page+1), per-page=\(limit)")
        APIClient.fetchUser(page: page+1, perPage: limit) { (result) in
            switch result.response?.statusCode {
            case 200?:
                if  let data = result.data,
                    let userResponseModel = try? JSONDecoder().decode(UserResponse.self, from: data) {

                    if shouldAppend == false {
                        self.users.removeAll()
                    }
                    self.users.append(contentsOf: userResponseModel.data)
                    self.delegate?.userFetched(success: true, userCount: userResponseModel.data.count)
                } else {
                    self.delegate?.userFetched(success: false, userCount: 0)
                }
            default:
                self.delegate?.userFetched(success: false, userCount: 0)
            }
        }
    }
}
