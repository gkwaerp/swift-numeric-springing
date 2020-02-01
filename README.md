# Numeric Springing in Swift
A framework for numeric springing in Swift, written in **Swift 5**, currently supporting **iOS 10 and newer**.

Allows easy creation of spring animations, in cases where e.g. `UIView.animate` isn't a viable option.

## Setup
### Swift Package Manager
With your project opened in Xcode, follow these steps to add the Numeric Springing framework to your project:
1. Select your project.
2. Click 'Swift Packages'.
3. Click the Add button.
4. Enter the following repository URL: `https://github.com/LactoseGK/swift-numeric-springing`.
5. Click 'Next'.
6. Select your preferred import/version rules. Unless you have specific reasons not to, I recommend using the default settings.
7. Click 'Next'.
8. Ensure the Package `NumericSpringing` is selected, and that the correct target is selected.
9. Click 'Finish'.

You will need to include `import NumericSpringing` in the source files which use the Numeric Springing framework.

## How to use
### Code Examples
Code goes here.
### Example Repository
Link goes here.

## Supported types
The Numeric Springing framework works by making a type conform to the `Springable` protocol. A `Spring` operates on `Springable` objects. Internally, the Numeric Spring framework does math using `Double`.

This means that custom classes can support the Numeric Springing framework. The only requirements to conform to the `Springable` protocol is that the class must be able to convert from and to 1 or more `Double` values.

### Already supported types
The following types are already supported in the Numeric Springing framework:
* Double.
* CGFloat.
* CGPoint.

### Adding support for new types
To add support for a new type, make the type conform to the `Springable`protocol. The `Springable` protocol has 2 requirements:
* `public var values: [Double]` -- Convert an object of the required type into an array of Doubles, for use internally in the Numeric Spring framework.

* `public static func from(values: [Double]) -> T` -- Given an array of Doubles, create an object of the required type.

#### Example, CGFloat
```
extension CGFloat: Springable {
    public var values: [Double] {
        return [Double(self)]
    }

    public static func from(values: [Double]) -> CGFloat {
        guard values.count == 1 else { fatalError("Attemping to create 1x CGFloat from \(values.count) values.") }
        return CGFloat(values[0])
    }
}
```

## Credits/Acknowledgements
Based on [Ming-Lun "Allen" Chou](https://github.com/TheAllenChou)'s blog posts on numeric springing:
* [Precise Control over Numeric Springing](http://allenchou.net/2015/04/game-math-precise-control-over-numeric-springing/)
* [Numeric Springing Examples](http://allenchou.net/2015/04/game-math-numeric-springing-examples/)
* [More on Numeric Springing](http://allenchou.net/2015/04/game-math-more-on-numeric-springing/)
