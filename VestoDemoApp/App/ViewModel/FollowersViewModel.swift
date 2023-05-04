//
//  FollowersViewModel.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 3. 5. 2023..
//

import Foundation
import RxSwift
import RxCocoa

protocol FollowersViewModelProtocol {
    var followers: Observable<[Follower]> { get }
    func viewInitialized()
}

class FollowersViewModel: FollowersViewModelProtocol {
    
    // MARK: Protocol implementation
    var followers: Observable<[Follower]> {
        return _followers
    }
    
    // MARK: Required properties
    private let service: UserServiceProviding
    private let coordinator: MainCoordinating
    
    public weak var view: FollowersScene?
    
    // MARK: Private properties
    private let _followers = PublishSubject<[Follower]>()
    private let disposeBag = DisposeBag()
    
    // MARK: Init methods
    init(service: UserServiceProviding, coordinator: MainCoordinating) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: Prototol functions
    func viewInitialized() {
        view?.didTapOnUserName.subscribe(onNext: { [weak self] username in
            self?.coordinator.presentUserDetails(with: username)
        }).disposed(by: disposeBag)
        
        refreshFollowers()
    }
    
    // MARK: Private functions 
    private func refreshFollowers() {
        
        service
            .getFollowers()
            .subscribe(onNext: { [unowned self] response in
                switch response {
                case let .success(data):
                    self._followers.onNext(
                        data.map {
                            return Follower(
                                username: $0.login,
                                id: $0.id,
                                avatar: $0.avatar_url,
                                userType: $0.type
                            )
                        }
                    )
               
                case let .failure(error):
                   print(error)
                }
            })
            .disposed(by: disposeBag)
    }
}

