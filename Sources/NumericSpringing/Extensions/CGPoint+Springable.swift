//
//  CGPoint+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

#if canImport(UIKit)
import UIKit

extension CGPoint: Springable {
    public var values: [Double] {
        return [Double(self.x), Double(self.y)]
    }
    
    public static func from(values: [Double]) -> CGPoint {
        guard values.count == numValuesNeededForInitialization else { fatalError("Attemping to create 1 CGPoint from \(values.count) values.")}
        return CGPoint(x: values[0], y: values[1])
    }

    public static var numValuesNeededForInitialization: Int {
        return 2
    }
}
#endif
