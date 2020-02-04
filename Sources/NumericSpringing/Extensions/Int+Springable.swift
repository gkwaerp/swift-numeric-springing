//
//  File.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 03/02/2020.
//

import Foundation

extension Int: Springable {
    public static var numValuesNeededForSpringInitialization: Int {
        return 1
    }
    
    public var values: [Double] {
        return [Double(self)]
    }
    
    public static func from(values: [Double]) -> Int {
        guard values.count == numValuesNeededForSpringInitialization else {
            fatalError("Attemping to create 1x Int from \(values.count) values. Expected \(numValuesNeededForSpringInitialization).")
        }
        return Int(round(values[0]))
    }
}
