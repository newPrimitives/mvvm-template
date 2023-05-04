//
//  APIRouter.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 26. 4. 2023..
//

import Foundation

enum APIRouter {
    
    case followers
    case user(username: String)
    
    var baseUrl: String {
        return "https://api.github.com/"
    }
    
    var stringUrl: String {
        switch self {
        case .followers:
            return baseUrl + APIRoutes.followers
        case .user(let username):
            return baseUrl + APIRoutes.user + username
        }
    }
    
    func getUrl() -> String {
        return stringUrl
    }
}
