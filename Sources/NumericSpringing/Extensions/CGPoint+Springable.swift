//
//  CGPoint+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

#if canImport(UIKit)
import UIKit

extension CGPoint: Springable {
    public static var numValuesNeededForSpringInitialization: Int {
        return 2
    }
    
    public var values: [Double] {
        return [Double(self.x), Double(self.y)]
    }
    
    public static func from(values: [Double]) -> CGPoint {
        guard values.count == numValuesNeededForSpringInitialization else {
            fatalError("Attemping to create 1x CGPoint from \(values.count) values. Expected \(numValuesNeededForSpringInitialization).")
        }
        return CGPoint(x: values[0], y: values[1])
    }
}
#endif
