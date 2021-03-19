//
//  Operations.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/16/21.
//

import Foundation

enum Operation: String, CaseIterable {
    case addition = "+"
    case substraction = "-"
    case multiplication = "*"
    case division = "/"
    
    var stringOperations: [String] {
        switch self {
            case .addition:         return ["+", "➕", "plus"]
            case .substraction:     return ["-", "➖", "minus"]
            case .multiplication:   return ["*", "x", "✖️", "✖", "times"]
            case .division:         return ["/", "%", "➗", "divided by"]
        }
    }
    
    
    func doOperation(number1: Double, number2: Double) -> Double {
        switch self {
            case .addition:         return number1 + number2
            case .substraction:     return number1 - number2
            case .multiplication:   return number1 * number2
            case .division:         return number1 / number2
        }
    }
}
