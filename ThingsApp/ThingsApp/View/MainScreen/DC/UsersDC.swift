//
//  UsersDC.swift
//  RSS-Reader
//
//  Created by Isidora Lazic on 14.3.22..
//

import Foundation
import Combine
final class UsersDC {
    
    // MARK: - Singleton
    
    static let shared = UsersDC()
    
    // MARK: - Properties
    
    //private let baseURL = "https://gorest.co.in/public/v2/"
    //private let baseURL = "https://jsonplaceholder.typicode.com/"
    private let decoder = JSONDecoder()
    var users = [User]()
    var selectedUsers: [User] {
        let selectedUsersFiltered = users.filter { $0.isSelected }
        return selectedUsersFiltered
    }

    // MARK: - API
    
    func getUsers(completion: @escaping (_ finishedWithSuccess: Bool, _ error: CustomError?) -> Void) {
        Network.shared.sendRequest(to: Bundle.main.infoDictionary?["BASE_URL"] as! String) { [weak self] response in
            do {
                if let data = try response(),
                   let newUsers = try self?.decoder.decode([User].self, from: data)
                {
                    self?.users = newUsers
                    completion(true, nil)
                }
            } catch {
                print("Error fetching JSON response: \(error)")
                completion(false, error as? CustomError)
            }
        }
    }
    
    func addUser(userID: Int, name: String) {
        let newUser = User(userID: userID, name: name, email: nil, gender: nil, status: nil)
        users.insert(newUser, at: 0)
        print("UserID: \(newUser.userID ?? -1) Name: \(newUser.name ?? "")")
    }
}
