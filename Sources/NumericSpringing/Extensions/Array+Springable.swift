//
//  File.swift
//  
//
//  Created by Geir-Kåre S. Wærp on 03/02/2020.
//

import Foundation

// TODO: I believe this fails with nested arrays...
extension Array: Springable where Iterator.Element: Springable {
    public static var numValuesNeededForSpringInitialization: Int {
        return 1
    }

    public var values: [Double] {
        var array = [Double]()
        self.forEach { (springable) in
            array.append(contentsOf: springable.values)
        }
        return array
    }

    public static func from(values: [Double]) -> Array<Element> {
        guard values.count > 0 else {
            return []
        }
        guard values.count % Element.numValuesNeededForSpringInitialization == 0  else {
            fatalError("Number of elements in array (\(values.count)) doesn't divide evenly into amount needed for initialization (\(Element.numValuesNeededForSpringInitialization)).")
        }
        
        let numLoops = values.count / Element.numValuesNeededForSpringInitialization
        var newArray = [Element]()
        var tempArray = values
        for _ in 0..<numLoops {
            let initializationArray = [Double](tempArray.prefix(Element.numValuesNeededForSpringInitialization))
            newArray.append(Element.from(values: initializationArray))
            tempArray = [Double](tempArray.dropFirst(Element.numValuesNeededForSpringInitialization))
        }

        return newArray
    }
}
