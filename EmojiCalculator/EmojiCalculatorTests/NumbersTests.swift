//
//  NumbersTests.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/17/21.
//

import XCTest
@testable import EmojiCalculator

final class NumbersTests: XCTestCase {

    let numberConverter = NumberConverter()

    func test_regularNumbers() {
        let number0 = numberConverter.convertFromSymbol("0")
        XCTAssertEqual(number0, 0)
        
        let number9 = numberConverter.convertFromSymbol("9")
        XCTAssertEqual(number9, 9)
    }
    
    func test_regularEmojiNumbers() {
        let number0 = numberConverter.convertFromSymbol("0️")
        XCTAssertEqual(number0, 0)
        
        let number9 = numberConverter.convertFromSymbol("9️")
        XCTAssertEqual(number9, 9)
    }
    
    func test_specialEmojiNumbers() {
        let number8 = numberConverter.convertFromSymbol("🎱")
        XCTAssertEqual(number8, 8)
        
        let number10 = numberConverter.convertFromSymbol("🔟")
        XCTAssertEqual(number10, 10)
        
        let number100 = numberConverter.convertFromSymbol("💯")
        XCTAssertEqual(number100, 100)
    }

    func test_convertedEmojiString() {
        let convertedString = numberConverter.convertToEmoji(from: "1001040")
        XCTAssertEqual(convertedString, "💯🔟4️0️")
    }
}
