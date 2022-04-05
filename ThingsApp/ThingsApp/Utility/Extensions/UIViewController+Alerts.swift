//
// UIViewController+Alerts.swift
//
// Copyright (c) 2016 Marko Tadić <tadija@me.com> http://tadija.net
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit

public extension UIViewController {
    
    // MARK: - API
    
    class var alertDefaultButtonTitle: String {
        return "Ok"
    }
    
    func presentAlert(title: String? = nil,
                      message: String? = nil,
                      buttonTitle: String? = alertDefaultButtonTitle,
                      buttonStyle: UIAlertAction.Style = .default,
                      buttonHandler: ((UIAlertAction) -> Void)? = nil,
                      completion: (() -> Void)? = nil) {
        let action = UIAlertAction(title: buttonTitle, style: buttonStyle, handler: buttonHandler)
        presentAlert(title: title, message: message, actions: [action], completion: completion)
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      actions: [UIAlertAction],
                      completion: (() -> Void)? = nil) {
        presentAlertStyle(title: title, message: message, actions: actions, completion: completion)
    }
    
    func presentActionSheet(title: String?,
                            message: String?,
                            actions: [UIAlertAction],
                            completion: (() -> Void)? = nil) {
        presentActionSheetStyle(title: title, message: message, actions: actions, completion: completion)
    }
    
    // MARK: - Helpers
    
    private func presentAlertStyle(title: String?,
                                   message: String?,
                                   actions: [UIAlertAction],
                                   completion: (() -> Void)? = nil) {
        presentAlertController(title: title, message: message, actions: actions, style: .alert, completion: completion)
    }
    
    private func presentActionSheetStyle(title: String?,
                                         message: String?,
                                         actions: [UIAlertAction],
                                         completion: (() -> Void)? = nil) {
        presentAlertController(title: title, message: message, actions: actions, style: .actionSheet, completion: completion)
    }
    
    private func presentAlertController(title: String?,
                                        message: String?,
                                        actions: [UIAlertAction],
                                        style: UIAlertController.Style,
                                        completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: completion)
    }
}
