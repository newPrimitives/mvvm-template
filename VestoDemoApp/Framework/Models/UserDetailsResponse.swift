//
//  UserDetailsResponse.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 4. 5. 2023..
//

import Foundation

struct UserDetailsResponse: Codable {
    
    let name: String
    let login: String
    let avatar_url: String
    let bio: String
    let html_url: String
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
}
