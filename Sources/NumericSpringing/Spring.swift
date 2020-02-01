//
//  Spring.swift
//
//
//  Created by Geir-Kåre S. Wærp on 01/02/2020.
//
import Foundation

// Based on the blogs posts on Numeric Springing by Ming-Lun "Allen" Chou | 周明倫:
// * http://allenchou.net/2015/04/game-math-precise-control-over-numeric-springing/
// * http://allenchou.net/2015/04/game-math-numeric-springing-examples/
// * http://allenchou.net/2015/04/game-math-more-on-numeric-springing/

// Simulates a dampened spring system.
@available(OSX 10.12, *)
public class Spring<T: Springable> {
    public typealias SpringCompletionBlock = () -> ()
    public typealias SpringAnimationBlock = (T) -> Void
    
    enum SpringType {
        case performance
        case stable
    }
 
    // MARK: - Variables
    // MARK: Spring computation
    /// Value
    private var x: [Double]

     /// Velocity
    private var v: [Double]
    
    /// Target value
    private var xt: [Double]
    
    /// Damping ratio
    private let zeta: Double
    
    /// Angular frequency
    private let omega: Double
    
    /// Time step
    private let h: Double

    // MARK: Closures & updating
    // TODO: CADisplayLink instead of Timer?
    private var springType: SpringType
    private var timer: Timer?
    private var animationClosure: SpringAnimationBlock
    private var completionClosure: SpringCompletionBlock?

    // MARK: 'At Rest' detection
    private let numRestsForCompletion = 3
    private let restEpsilon = 0.00001
    private var restCounter = 0
    private var oldX: [Double]? = nil
    
    // MARK: - Factory methods
    public static func createBasicSpring(startValue: T, animationClosure: @escaping SpringAnimationBlock) -> Spring {
        return Spring(startValue: startValue,
                      oscillationFrequency: 2.8,
                      halfLife: 0.1,
                      animationClosure: animationClosure,
                      completion: nil)
    }
    
    public static func createCustomSpring(startValue: T,
                                   velocity: T? = nil,
                                   oscillationFrequency: Double,
                                   halfLife: Double,
                                   timeStep: Double = 1.0 / 120.0,
                                   animationClosure: @escaping SpringAnimationBlock,
                                   completion: SpringCompletionBlock? = nil) -> Spring {
        return Spring(startValue: startValue,
                      velocity: velocity,
                      oscillationFrequency: oscillationFrequency,
                      halfLife: halfLife,
                      animationClosure: animationClosure,
                      completion: completion)
    }

    // MARK: - Initialization & Deinitialization
    private init(startValue: T,
                 targetValues: T? = nil,
                 velocity: T? = nil,
                 oscillationFrequency f: Double,
                 halfLife lambda: Double,
                 timeStep: Double = 1.0 / 120.0,
                 animationClosure: @escaping SpringAnimationBlock,
                 completion: SpringCompletionBlock?,
                 springType: SpringType = .performance) {
        
        let angularFrequency = 2 * Double.pi * f
        let dampingRatio = -log(0.5) / (angularFrequency * lambda)

        self.x = startValue.values
        self.v = velocity?.values ?? Array(repeating: 0.0, count: startValue.values.count)
        self.xt = targetValues?.values ?? startValue.values
        self.zeta = dampingRatio
        self.omega = angularFrequency
        self.h = timeStep
        self.animationClosure = animationClosure
        self.completionClosure = completion
        self.springType = springType
        
        guard self.x.count == self.xt.count else { fatalError("There must be the same number of values for the starting values and the target values. Number of starting values \(self.x.count) != number of target values \(self.xt.count)") }
    }
    
    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }


    // MARK: - Setting new values
    public func updateCurrentValue(_ currentValue: T) {
        guard self.x.count == currentValue.values.count else { fatalError("Attempting to update current values to a new amount of values. Must be \(self.x.count), was \(currentValue.values.count)") }
        self.x = currentValue.values
    }

    public func updateTargetValue(_ targetValue: T, startIfPaused: Bool = true) {
        guard self.xt.count == targetValue.values.count else { fatalError("Attempting to update target values to a new amount of values. Must be \(self.xt.count), was \(targetValue.values.count)") }
        self.xt = targetValue.values
        if self.timer == nil && startIfPaused {
            self.startTimer()
        }
    }
    
    public func updateCompletionClosure(_ completionClosure: SpringCompletionBlock?) {
        self.completionClosure = completionClosure
    }

    // MARK: - Starting & Stopping
    public func startSpringAnimation() {
        self.startTimer()
    }
    
    private func startTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: self.h, repeats: true) { (_) in
            self.update()
        }
    }

    public func stop() {
        self.restCounter = 0
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Updating
    @objc private func update() {
        switch self.springType {
        case .performance:
            self.updateSemiImplicitEuler()
        case .stable:
            self.updateImplicitEuler()
        }

        self.updateRestCounter()
        self.animationClosure(T.from(values: self.x))
        self.stopIfResting()
    }

    private func updateSemiImplicitEuler() {
        for i in 0..<self.v.count {
            self.v[i] += -2.0 * self.h * self.zeta * self.omega * self.v[i] + self.h * self.omega * self.omega * (self.xt[i] - self.x[i])
            self.x[i] += self.h * self.v[i]
        }
    }

    private func updateImplicitEuler() {
        let f = 1.0 + 2.0 * self.h * self.zeta * self.omega
        let oo = self.omega * self.omega
        let hoo = self.h * oo
        let hhoo = self.h * hoo
        let detInv = 1.0 / (f + hhoo)
        for i in 0..<self.v.count {
            let detX = f * self.x[i] + self.h * self.v[i] + hhoo * self.xt[i]
            let detV = self.v[i] + hoo * (self.xt[i] - self.x[i])
            self.x[i] = detX * detInv
            self.v[i] = detV * detInv
        }
    }

    // MARK: - 'At Rest' detection
    private func updateRestCounter() {
        if let oldX = self.oldX {
            let allAtRest = self.x.enumerated().allSatisfy { (index, value) -> Bool in
                return abs(oldX[index] - value) < self.restEpsilon
            }
            
            if allAtRest {
                self.restCounter += 1
            } else {
                self.oldX = self.x
                self.restCounter = 0
            }
        } else {
            self.oldX = self.x
        }
    }

    private func stopIfResting() {
        if self.restCounter >= self.numRestsForCompletion {
            self.stop()
            self.animationClosure(T.from(values: self.xt))
            self.completionClosure?()
        }
    }
}

