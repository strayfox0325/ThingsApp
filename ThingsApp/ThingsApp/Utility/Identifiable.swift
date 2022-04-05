//
//  Identifiable.swift
//  CERApp
//
//  Created by Ana Videnovic on 8/5/19.
//  Copyright © 2019 Vanja Kovacevic. All rights reserved.
//

import Foundation

protocol Identifiable: AnyObject {
	static var identifier: String { get }
}

extension Identifiable {
	static var identifier: String {
		return String(describing: self)
	}
}
