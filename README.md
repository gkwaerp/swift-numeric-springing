# Numeric Springing in Swift
A framework for numeric springing in Swift, written in **Swift 5**, currently supporting **iOS 10 and newer**.

Allows easy creation of spring animations, in cases where e.g. `UIView.animate` isn't a viable option, e.g. if the target value can change dynamically at any given time.

## Setup
### Swift Package Manager
With your project opened in Xcode, follow these steps to add the Numeric Springing framework to your project:
1. Select your project.
2. Click `Swift Packages`.
3. Click the Add button (`+` symbol).
4. Enter the following repository URL: `https://github.com/LactoseGK/swift-numeric-springing`.
5. Click `Next`.
6. Select your preferred import/version rules. Unless you have specific reasons not to, I recommend using the default settings.
7. Click `Next`.
8. Ensure the Package `NumericSpringing` is selected, and that the correct target is selected.
9. Click `Finish`.

You will need to include `import NumericSpringing` in the source files which use the Numeric Springing framework.

## How to use
To use a spring, you will generally need to store it in a variable, in order to update its target values.
### Code Example -- toggling rotation of a view
For this, we need a view to rotate, as well as 2 other variables -- one for the spring, and one to keep track of which rotation value we're wanting.
```
private var rotateView: UIView!
private var rotateSpring: Spring<CGFloat>?
private var rotateToggled = false
```

For convenience, we'll have a variable that gives us our target rotation value:
```
private var rotationValue: CGFloat {
    return self.rotateToggled ? CGFloat.pi / 2 : 0
}
```

Next, we create the spring. This is also where we have our animation closure. Remember to consider retain cycles here, and apply `[weak self]` as appropriate:
```
self.rotateSpring = .createBasicSpring(startValue: self.rotationValue, animationClosure: { [weak self] (animationValue) in
    self?.rotateView.transform = CGAffineTransform(rotationAngle: animationValue)
})
```
Note that creating a spring does not make it animate automatically. To start the animation, either call `startSpringAnimation()`, or `updateTargetValue` with the `startIfPaused` flag set to `true` (default = `true`).

Finally, we add a gesture recognizer to allow us to tap our `rotateView`.
```
self.rotateView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rotateViewTapped)))
// ...
@objc func rotateViewTapped() {
    self.rotateToggled.toggle()
    self.rotateSpring?.updateTargetValue(self.rotationValue)
}
```
Tapping `rotateView` will now cause it to rotate with a spring. Note also that the target value can be updated at any time, and the spring will dynamically feed the animation closure with the correct animation values.


In addition to `createBasicSpring`, there is also factory method called `createCustomSpring` -- this allows you to tweak the various parameters to get the desired effect.


### Example Repository
A sample project showcasing some animations which can be made using this framework can be found [here](https://github.com/LactoseGK/swift-numeric-springing-examples).

## Supported types
The Numeric Springing framework works by making a type conform to the `Springable` protocol. A `Spring` operates on `Springable` objects. Internally, the Numeric Spring framework does math using `Double`.

This means that custom classes and structs can support the Numeric Springing framework. The only requirements to conform to the `Springable` protocol is that the class/struct must be able to convert from and to 1 or more `Double` values.

### Already supported types
The following types are already supported in the Numeric Springing framework:
* Double.
* CGFloat.
* CGPoint.
* Int.
* Arrays of supported types are also supported (non-nested).

### Adding support for new types
To add support for a new type, make the type conform to the `Springable`protocol. The `Springable` protocol has 3 requirements:
* `public static var numValuesNeededForSpringInitialization: Int { get }` -- How many Doubles are consumed when initializing a single instance of the object. For array purposes.

* `public var values: [Double] { get }` -- Convert an object of the required type into an array of Doubles, for use internally in the Numeric Spring framework.

* `public static func from(values: [Double]) -> T` -- Given an array of Doubles, create an object of the required type.

#### Example, CGFloat
```
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
```

## Known issues/TODOs
* Supporting nested arrays.

## Credits/Acknowledgements
Based on [Ming-Lun "Allen" Chou](https://github.com/TheAllenChou)'s blog posts on numeric springing:
* [Precise Control over Numeric Springing](http://allenchou.net/2015/04/game-math-precise-control-over-numeric-springing/)
* [Numeric Springing Examples](http://allenchou.net/2015/04/game-math-numeric-springing-examples/)
* [More on Numeric Springing](http://allenchou.net/2015/04/game-math-more-on-numeric-springing/)
