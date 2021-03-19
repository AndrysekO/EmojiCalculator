//
//  Error.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/17/21.
//

enum Error: Equatable {
    case invalidCharacter(character: String)
    case divisionByZero
    case startWithOperator
    case endWithOperator
    case statementIsEmpty
    case invalidStatement
    case numberIsTooBig(number: String)
    
    var message: String {
        switch self {
            case .invalidCharacter(let character):      return "Invalid character: \(character)"
            case .divisionByZero:                       return "Division by zero is not allowed"
            case .startWithOperator:                    return "The formula starts with an operator"
            case .endWithOperator:                      return "The formula ends with an operator"
            case .statementIsEmpty:                     return "The statement is empty"
            case .invalidStatement:                     return "Invalid statement"
            case .numberIsTooBig(let number):           return "Number: \(number) is too big"
        }
    }
}
