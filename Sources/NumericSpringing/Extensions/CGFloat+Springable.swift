//
//  CGFloat+Springable.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//

#if canImport(UIKit)
import UIKit

extension CGFloat: Springable {
    public var values: [Double] {
        return [Double(self)]
    }

    public static func from(values: [Double]) -> CGFloat {
        guard values.count == numValuesNeededForInitialization else { fatalError("Attemping to create 1 CGFloat from \(values.count) values.") }
        return CGFloat(values.first!)
    }

    public static var numValuesNeededForInitialization: Int {
        return 1
    }
}

#endif
