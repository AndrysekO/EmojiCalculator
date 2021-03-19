//
//  OperationsTests.swift
//  EmojiCalculatorTests
//
//  Created by Ondrej Andrysek on 3/17/21.
//

import XCTest
@testable import EmojiCalculator

final class EmojiCalculatorTests: XCTestCase {
    
    func test_addition() {
        let result = Operation.addition.doOperation(number1: 6, number2: 3)
        XCTAssertEqual(result, 9)
    }
    
    func test_substraction() {
        let result = Operation.substraction.doOperation(number1: 6, number2: 3)
        XCTAssertEqual(result, 3)
    }
    
    func test_multiplication() {
        let result = Operation.multiplication.doOperation(number1: 6, number2: 3)
        XCTAssertEqual(result, 18)
    }
    
    func test_division() {
        let result = Operation.division.doOperation(number1: 6, number2: 3)
        XCTAssertEqual(result, 2)
    }

}
