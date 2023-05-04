//
//  MainCoordinator.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 3. 5. 2023..
//

import Foundation
import UIKit

protocol MainCoordinating {
    func connect() -> UINavigationController
    func presentUserDetails(with username: String)
}

class MainCoordinator: MainCoordinating {
    
    private let navigationController: UINavigationController = {
        let navigation = UINavigationController()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigation.navigationBar.standardAppearance = appearance
        return navigation
    }()
    
    init() {
        
    }
    
    func connect() -> UINavigationController {
        let service = UserService()
        let viewModel = FollowersViewModel(service: service, coordinator: self)
        let view = FollowersViewController(viewModel: viewModel)
        viewModel.view = view
        navigationController.viewControllers = [view]
        return navigationController
    }
    
    func presentUserDetails(with username: String) {
        let service = UserService()
        let viewModel = UserDetailsViewModel(service: service, username: username)
        let view = UserDetailsViewController(viewModel: viewModel)
        navigationController.present(view, animated: true)
    }
}
