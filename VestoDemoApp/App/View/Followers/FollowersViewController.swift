//
//  FollowersViewController.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 26. 4. 2023..
//

import UIKit
import RxSwift

protocol FollowersScene: AnyObject {
    var didTapOnUserName: Observable<String> { get }
}

class FollowersViewController: UIViewController, FollowersScene {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Protocol implementation
    var didTapOnUserName: Observable<String> {
        return _didTapOnUserName
    }
    
    // MARK: Private properties
    private let _didTapOnUserName = PublishSubject<String>()
    private let viewModel: FollowersViewModelProtocol
    private let _followers = BehaviorSubject<[Follower]>.init(value: [])
    private let disposeBag = DisposeBag()
    private static let followersHeaderTableViewCell = "FollowersHeaderTableViewCell"
    private static let followerTableViewCell = "FollowerTableViewCell"
    
    // MARK: Init methods
    init(viewModel: FollowersViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: "FollowersViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeTableView()
        registerDataSourceCells()
        viewModel.followers.bind(to: _followers).disposed(by: disposeBag)
        viewModel.viewInitialized()
    }
    
    private func initializeTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
        
    private func registerDataSourceCells() {
        _followers.subscribe(onNext: { [unowned self] _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        tableView.register(
            UINib(nibName: FollowersViewController.followersHeaderTableViewCell, bundle: nil),
            forCellReuseIdentifier: FollowersViewController.followersHeaderTableViewCell
        )
        tableView.register(
            UINib(nibName: FollowersViewController.followerTableViewCell, bundle: nil),
            forCellReuseIdentifier: FollowersViewController.followerTableViewCell
        )
    }
}

extension FollowersViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: FollowersViewController.followerTableViewCell, for: indexPath) as!     FollowerTableViewCell
        
        do {
            let data = try _followers.value()[indexPath.row]
            cell.setup(with: data.avatar, name: data.username, type: data.userType)
            
        } catch {
            cell.setupNoDataLayout()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do {
            return try _followers.value().count
        } catch {
           return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let cell = tableView.dequeueReusableCell(withIdentifier: FollowersViewController.followersHeaderTableViewCell) as! FollowersHeaderTableViewCell
        return cell
    }
}

extension FollowersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        do {
            let data = try _followers.value()[indexPath.row]
            _didTapOnUserName.onNext(data.username)
            
        } catch {
            print("something went wrong")
        }
    }
}
