//
//  Observable+Object.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 26. 4. 2023..
//

import Foundation
import RxAlamofire
import RxSwift

enum ApiResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value) {
        self = .success(value)
    }
    
    init(error: Error) {
        self = .failure(error)
    }
}

struct ApiErrorMessage: Codable {
    var error_message: String
}

extension Observable where Element == (HTTPURLResponse, Data) {
    
    func expectingObject<T : Codable>(ofType type: T.Type) ->             Observable<ApiResult<T, ApiErrorMessage>> {
        
            return self.map { (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
                switch httpURLResponse.statusCode {
                case 200...299:
                    // is status code is successful we can safely decode to our expected type T
                    let object = try JSONDecoder().decode(type, from: data)
                    return .success(object)
                default:
                    if let apiErrorMessage = try? JSONDecoder().decode(ApiErrorMessage.self, from: data) {
                        
                        return .failure(apiErrorMessage)
                        
                    } else {
                        return .failure(ApiErrorMessage(error_message: "Generic error"))
                    }
                    
                }
            }
    }
}
