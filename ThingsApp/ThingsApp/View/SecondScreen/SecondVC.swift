//
//  SecondVC.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 15.3.22..
//

import UIKit

class SecondVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var chosenUserView: UIView!
    @IBOutlet weak var chosenUserLabel: UILabel!
    @IBOutlet weak var userDetailsLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Properties
    
    var selectedUsers = [User]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.register(UserCell.nib, forCellReuseIdentifier: UserCell.identifier)
        updateChosenUsersView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func updateChosenUsersView() {
        chosenUserView.layer.cornerRadius = 10
    }
    
    private func animateSelection() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.chosenUserView.backgroundColor = UIColor(red: 229, green: 183, blue: 222)
            self.chosenUserView.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            self.chosenUserView.layer.cornerRadius = 40
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                self.chosenUserView.transform = CGAffineTransform.identity
                self.chosenUserView.backgroundColor = UIColor(red: 175, green: 82, blue: 222)
                self.chosenUserView.layer.cornerRadius = 10
            })
        }
    }
}

// MARK: - UITableViewDelegate

extension SecondVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = selectedUsers[indexPath.item]
        animateSelection()
        userDetailsLabel.text = selectedUser.name
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.50) {
            cell.alpha = 1
        }
    }
}

// MARK: - UITableViewDataSource

extension SecondVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell {
            let user = selectedUsers[indexPath.item]
            cell.nameLabel.text = user.name
            cell.index = indexPath.row
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
