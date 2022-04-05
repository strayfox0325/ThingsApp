//
//  UserCell.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 14.3.22..
//

import UIKit

class UserCell: UITableViewCell, NibProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            updateUI()
        }
    }
    
    var index: Int = 0  {
        didSet {
            updateBG()
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
    }
    
    // MARK: - Helpers
    
    func updateUI() {
        if let user = user {
            nameLabel.text = user.name
            checkmarkImageView.isHidden = !user.isSelected
        }
    }
    
    func updateBG() {
        let newBackgroundColor = UIColor(red: 157 + (index * 4), green: 137, blue: 255)
        bgView.backgroundColor = newBackgroundColor
    }
}
