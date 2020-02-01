//
//  Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

import Foundation

public protocol Springable {
    var values: [Double] { get }
    static func from(values: [Double]) -> Self
    static var numValuesNeededForInitialization: Int { get }
}
