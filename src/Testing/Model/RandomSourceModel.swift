//
//  RandomSourceModel.swift
//  ur-Tests
//
//  Created by Anton on 8/2/18.
//  Copyright © 2018 LCTeam. All rights reserved.
//

import GameplayKit

class SingleValueRandom: GKRandom {
    var value: Int

    init(_ value: Int) {
        self.value = value
    }

    func nextInt() -> Int { return value }
    func nextInt(upperBound: Int) -> Int { return value }
    func nextUniform() -> Float { return Float(value) }
    func nextBool() -> Bool { return value != 0 }
}


class LinearSequenceRandom: GKRandom {

    var lowerBound: Int {
         didSet { currentValue = max(currentValue, lowerBound) }
    }

    var upperBound: Int {
        didSet { currentValue = min(currentValue, upperBound) }
    }

    private var currentValue: Int {
        didSet { assert(currentValue >= lowerBound && currentValue <= upperBound) }
    }


    private var next: Int {
        currentValue = (currentValue - lowerBound &+ 1) % (upperBound - lowerBound &+ 1) + lowerBound
        return currentValue
    }

    init(lower: Int = 0, upper: Int = Int.max) {
        self.lowerBound = lower
        self.upperBound = upper
        self.currentValue = upper
    }

    func nextInt() -> Int { return next }
    func nextInt(upperBound: Int) -> Int { return next % upperBound }
    func nextUniform() -> Float { return Float(next - lowerBound) / Float(upperBound - lowerBound) + Float(lowerBound) }
    func nextBool() -> Bool { return next % 2 != 0 }
}


class SequenceRandom: GKRandom {

    var sequence: [Int] {
        didSet { currentIndex = max(currentIndex, sequence.endIndex - 1) }
    }

    var currentIndex: Int {
        didSet { assert(currentIndex >= sequence.startIndex && currentIndex < sequence.endIndex) }
    }

    private var next: Int {
        currentIndex = (currentIndex + 1) % sequence.count
        return sequence[currentIndex]
    }

    init(_ sequence: [Int]) {
        self.sequence = sequence
        currentIndex = 0
    }

    func nextInt() -> Int { return next }
    func nextInt(upperBound: Int) -> Int { return next % upperBound }
    func nextUniform() -> Float { return Float(next) / Float(sequence.max()!) }
    func nextBool() -> Bool { return next != 0 }
}
