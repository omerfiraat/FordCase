//
//  APIEndpoint.swift
//  FordCase
//
//  Created by Mac on 29.09.2024.
//

import Foundation
import Alamofire

enum APIEndpoint {
    case searchUsers(query: String, page: Int)
    case userRepos(username: String, page: Int, perPage: Int)
    
    var path: String {
        switch self {
        case .searchUsers(let query, let page):
            return "/search/users?q=\(query)&page=\(page)&per_page=20"
        case .userRepos(let username, let page, let perPage):
            return "/users/\(username)/repos?type=owner&page=\(page)&per_page=\(perPage)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: Any]? {
        return nil
    }
}
