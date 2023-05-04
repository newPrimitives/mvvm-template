//
//  UserService.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 26. 4. 2023..
//

import RxAlamofire
import RxSwift

protocol UserServiceProviding {
    func getFollowers() -> Observable<ApiResult<[FollowersResponse], ApiErrorMessage>>
    func getUser(for username: String) -> Observable<ApiResult<UserDetailsResponse, ApiErrorMessage>>
}

class UserService: UserServiceProviding {
    
    private let disposeBag = DisposeBag()
    
    func getFollowers() -> Observable<ApiResult<[FollowersResponse], ApiErrorMessage>> {
        
        return RxAlamofire
            .request(.get, APIRouter.followers.getUrl(), parameters: nil)
            .responseData()
            .expectingObject(ofType: [FollowersResponse].self)
    }
    
    func getUser(for username: String) -> Observable<ApiResult<UserDetailsResponse, ApiErrorMessage>> {
        
        return RxAlamofire
            .request(.get, APIRouter.user(username: username).getUrl(), parameters: nil)
            .responseData()
            .expectingObject(ofType: UserDetailsResponse.self)
    }
}
