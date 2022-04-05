//
//  JSONDecoder.swift
//  ThingsApp
//
//  Created by Isidora Lazic on 14.3.22..
//

import Foundation

class JSONDecoder {
    
    func fetchData(url: String) {
        Network.shared.sendRequest(to: url) { [weak self] response in
            do {
                if let data = try response(),
                   let responseString = String(data: data, encoding: .utf8)
                {
                    let result = try JSONDecoder([User].self, from: data)
                    print("JSON Response:\n\n\(responseString)\n\n")
                    print("Result: \n\n\(result)")
                }
            } catch {
                print("Error fetching JSON response: \(error)")
            }
        }
    }
}


