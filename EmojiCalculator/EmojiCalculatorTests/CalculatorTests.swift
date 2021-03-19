//
//  CalculatorTests.swift
//  EmojiCalculatorTests
//
//  Created by Ondrej Andrysek on 3/18/21.
//

import XCTest
@testable import EmojiCalculator

final class CalculatorTests: XCTestCase {

    let calculator = Calculator()
    
    func test_transformedStatement_hasBasicCharacters() {
        let statement = calculator.transformedStatement("4️2️+🎱+25✖️2%🔟 +  💯   💯 plus 1").string!
        XCTAssertEqual(statement, "42+8+25*2/10+100100+1")
    }
    
    func test_validationError_whenStatementIsEmpty() {
        let error = calculator.transformedStatement("").error!
        XCTAssertEqual(error, .statementIsEmpty)
    }
    
    func test_validationError_whenDivisionByZero() {
        let error = calculator.transformedStatement("1/0").error!
        XCTAssertEqual(error, .divisionByZero)
    }
    
    func test_validationError_whenInvalidCharacter() {
        let error = calculator.transformedStatement("a1+2").error!
        XCTAssertEqual(error, .invalidCharacter(character: "a"))
    }
    
    func test_validationError_whenStartsWithAnOperator() {
        let error = calculator.transformedStatement("+1-1").error!
        XCTAssertEqual(error, .startWithOperator)
    }
    
    func test_validationError_whenTwoOperatorsAreNextToEachOther() {
        let error = calculator.transformedStatement("1++0").error!
        XCTAssertEqual(error, .invalidStatement)
    }
    
    func test_validationError_whenEndsWithAnOperator() {
        let error = calculator.transformedStatement("1+1-").error!
        XCTAssertEqual(error, .endWithOperator)
    }
    
    func test_validationError_whenNumberHasTwoPointsNextToEachOther() {
        let error = calculator.transformedStatement("1..0").error!
        XCTAssertEqual(error, .invalidStatement)
    }
    
    func test_validationError_whenNumberHasAnOperatorAndPoint() {
        let error = calculator.transformedStatement("1+.0").error!
        XCTAssertEqual(error, .invalidStatement)
    }
    
    func test_validationError_whenNumberHasPointAndOperator() {
        let error = calculator.transformedStatement("1.+0").error!
        XCTAssertEqual(error, .invalidStatement)
    }
    
    func test_validationError_whenNumberIsTooBig() {
        let error = calculator.transformedStatement("12345678*123/2").error!
        XCTAssertEqual(error, .numberIsTooBig(number: "12345678"))
    }
    
    func test_wholeNumberIsTruncatedNumber() {
        let truncatedNumber = calculator.floorNumber("5.0")
        XCTAssertEqual(truncatedNumber, "5")
    }
    
    func test_numberWithDecimalPointIsNotTruncatedNumber() {
        let truncatedNumber = calculator.floorNumber("5.2")
        XCTAssertEqual(truncatedNumber, "5.2")
    }
    
    func test_solveStatement_whenOperatorIsTakingPrecedence() {
        let newStatement = calculator.solveStatement("1+2+3*6/3")
        XCTAssertEqual(newStatement, "9.0")
    }
    
    func test_calculateOperationSolvesInCorrectOrder() {
        let newStatement = calculator.calculateOperations([.addition], statement: "1+2+3")
        XCTAssertEqual(newStatement, "3.0+3")
    }
    
    func test_calculate_whenComplexSolutionIsGiven() {
        let newStatement = calculator.calculate(statementString: "🔟+11*11-4%2-💯 + 🎱 ✖️   2 - 3 ")
        XCTAssertEqual(newStatement, "4️2️")
    }

}
