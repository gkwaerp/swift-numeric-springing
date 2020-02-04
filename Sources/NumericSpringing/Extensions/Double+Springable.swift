//
//  Double+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

import Foundation

extension Double: Springable {
    public static var numValuesNeededForSpringInitialization: Int {
        return 1
    }
    
    public var values: [Double] {
        return [self]
    }
    
    public static func from(values: [Double]) -> Double {
        guard values.count == numValuesNeededForSpringInitialization else {
            fatalError("Attemping to create 1x Double from \(values.count) values. Expected \(numValuesNeededForSpringInitialization).")
        }
        return values[0]
    }
}
