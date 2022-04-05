//
//  MainVC.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 14.3.22..
//

import UIKit
import XCTest

class MainVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var addUserButton: UIButton!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usersTableView.register(UserCell.nib, forCellReuseIdentifier: UserCell.identifier)
        UsersDC.shared.getUsers { [weak self] finishedWithSuccess, error in
            self?.loader.isHidden = true
            self?.usersTableView.isHidden = false
            self?.usersTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usersTableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.showSecondScreen {
            let secondVC = segue.destination as? SecondVC
            secondVC?.selectedUsers = UsersDC.shared.selectedUsers.sorted { $0.name ?? "" < $1.name ?? "" }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if UsersDC.shared.selectedUsers.count >= 3 {
            performSegue(withIdentifier: SegueIdentifiers.showSecondScreen, sender: self)
        } else {
            let okAction = UIAlertAction(title: "OK", style:  .default)
            self.presentAlert(title: "Invalid Input", message: "Please choose at least 3 fields", actions: [okAction])
        }
    }
    
    @IBAction func addUserButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: SegueIdentifiers.showAddUserScreen, sender: self)
    }
}

extension MainVC: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? UserCell
        UsersDC.shared.users[indexPath.row].isSelected.toggle()
        cell?.user = UsersDC.shared.users[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0.5
        UIView.animate(withDuration: 0.50) {
            cell.alpha = 1
        }
    }
}

// MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersDC.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell {
            cell.user = UsersDC.shared.users[indexPath.row]
            cell.index = indexPath.row
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            tableView.beginUpdates()
            UsersDC.shared.users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
