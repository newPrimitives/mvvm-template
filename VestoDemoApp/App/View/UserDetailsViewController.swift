//
//  UserDetailsViewController.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 4. 5. 2023..
//

import UIKit
import RxSwift

class UserDetailsViewController: UIViewController {

    private let viewModel: UserDetailsProtocol
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var publicReposLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var contentContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentContainer.layer.cornerRadius = 24
        avatarImageView.layer.cornerRadius = 120
        
        viewModel.viewInitialized()
        viewModel.user
            .subscribe(onNext: { [unowned self] user in
            if let user = user {
                self.setupView(with: user)
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupView(with user: User) {
        let url = URL(string: user.avatarUrl)
        avatarImageView.kf.setImage(with: url)
        nameLabel.text = user.name
        bioLabel.text = user.bio
        
        publicReposLabel.text = "\(user.publicRepos)"
        followersLabel.text = "\(user.followers)"
        followingLabel.text = "\(user.following)"
    }
    
    init(viewModel: UserDetailsProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "UserDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTapOnGithubLink(_ sender: Any) {
        viewModel.didTapOnGithubLink()
    }
}
