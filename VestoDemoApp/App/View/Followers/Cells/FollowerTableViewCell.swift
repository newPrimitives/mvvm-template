//
//  FollowerTableViewCell.swift
//  VestoDemoApp
//
//  Created by Nermin Sehic on 26. 4. 2023..
//

import UIKit
import Kingfisher

class FollowerTableViewCell: UITableViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var detailsBtn: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        container.layer.cornerRadius = 16
        detailsBtn.layer.cornerRadius = 16
        avatarImageView.layer.cornerRadius = 37
        selectionStyle = .none
    }
    
    func setup(with image: String, name: String, type: String) {
        userNameLabel.text = name
        userTypeLabel.text = type
        
        let url = URL(string: image)
        avatarImageView.kf.setImage(with: url)
    }
    
    func setupNoDataLayout() {
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
