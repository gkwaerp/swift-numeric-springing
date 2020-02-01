//
//  Double+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

import Foundation

extension Double: Springable {
    public var values: [Double] {
        return [self]
    }
    
    public static func from(values: [Double]) -> Double {
        guard values.count == numValuesNeededForInitialization else { fatalError("Attemping to create 1 Double from \(values.count) values.") }
        return values.first!
    }

    public static var numValuesNeededForInitialization: Int {
        return 1
    }
}
