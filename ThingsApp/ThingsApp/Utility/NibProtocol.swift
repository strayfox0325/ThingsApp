//
//  NibProtocol.swift
//  CERApp
//
//  Created by Ana Videnovic on 8/5/19.
//  Copyright © 2019 Vanja Kovacevic. All rights reserved.
//

import Foundation
import UIKit

protocol NibProtocol: Identifiable {
	static var nib: UINib { get }
}

extension NibProtocol {
	static var nib: UINib {
		return UINib(nibName: String(describing: self), bundle: nil)
	}
}

