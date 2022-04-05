//
//  AddUserVC.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 24.3.22..
//

import UIKit

class AddUserVC: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        updateUI()
        resetForm()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        errorLabel.isHidden = true
        nameTextField.resignFirstResponder()
    }
    
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if isUserDataValid() {
            let randomId = Int.random(in: 1...100)
            if let userName = nameTextField.text {
                let userId = randomId
                addUser(userID: userId, name: userName )
                resetForm()
            }
        }
    }
    
    @IBAction func nameTextFieldDidBegin(_ sender: UITextField) {
        errorLabel.isHidden = true
    }
    
    @IBAction func nameTextFieldDidChange(_ sender: UITextField) {
        errorLabel.isHidden = true
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true,completion: nil)
    }
    
    // MARK: - Helpers
    
    private func resetForm() {
        nameTextField.text = ""
        errorLabel.isHidden = true
    }
    
    private func updateUI() {
        addButton.layer.cornerRadius = 8
        backButton.layer.cornerRadius = 8
        nameTextField.layer.borderWidth = 0.8
        nameTextField.layer.borderColor = UIColor.purple.cgColor
    }
    
    private func isUserDataValid() -> Bool {
        var isValid = true
        if nameTextField.text == nil || nameTextField.text == "" {
            errorLabel.isHidden = false
            errorLabel.text = "Invalid name"
            isValid = false
        }
        return isValid
    }
    
    func addUser(userID: Int, name: String) {
        if isUserDataValid() {
            UsersDC.shared.addUser(userID: userID, name: name)
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate

extension AddUserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
