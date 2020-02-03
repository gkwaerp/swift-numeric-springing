//
//  Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

import Foundation

public protocol Springable {
    static var numValuesNeededForSpringInitialization: Int { get }
    var values: [Double] { get }
    static func from(values: [Double]) -> Self
}
