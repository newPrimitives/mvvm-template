//
//  UserDetailsViewModel.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 4. 5. 2023..
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

protocol UserDetailsProtocol {
    var user: Observable<User?> { get }
    func viewInitialized()
    func didTapOnGithubLink()
}

class UserDetailsViewModel: UserDetailsProtocol {
    
    // MARK: Protocol implementation
    var user: Observable<User?> {
        return _user
    }
    
    private let _user = BehaviorSubject<User?>.init(value: nil)
    
    // MARK: Required properties
    private let service: UserServiceProviding
    private let username: String
    
    private let disposeBag = DisposeBag()

    // MARK: Init methods
    init(service: UserServiceProviding, username: String) {
        self.service = service
        self.username = username
    }
    
    func viewInitialized() {
        getUserDetails()
    }
    
    func didTapOnGithubLink() {
        
        do {
            if let link = try _user.value()?.publicLink,
               let url = URL(string: link) {
                
                UIApplication.shared.open(url)
            }
            
        } catch {
            
        }
        
    }
    
    private func getUserDetails() {
        service
            .getUser(for: username)
            .subscribe(onNext: { [unowned self] response in
                switch response {
                case let .success(data):
                    self._user.onNext(
                        User(
                            name: data.name,
                            login: data.login,
                            avatarUrl: data.avatar_url,
                            bio: data.bio,
                            publicLink: data.html_url,
                            publicRepos: data.public_repos,
                            publicGists: data.public_gists,
                            followers: data.followers,
                            following: data.following
                        )
                    )
               
                case let .failure(error):
                   print(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
}
