//
//  CGFloat+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

#if canImport(UIKit)
import UIKit

extension CGFloat: Springable {
    public var numValuesNeededForSpringInitialization = 1
    
    public var values: [Double] {
        return [Double(self)]
    }

    public static func from(values: [Double]) -> CGFloat {
        guard values.count == numValuesNeededForSpringInitialization else {
            fatalError("Attemping to create 1x CGFloat from \(values.count) values. Expected \(numValuesNeededForSpringInitialization).")
        }
        return CGFloat(values[0])
    }
}

#endif
