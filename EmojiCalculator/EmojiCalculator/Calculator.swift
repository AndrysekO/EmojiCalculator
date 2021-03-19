//
//  Calculator.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/16/21.
//

import Foundation

struct Calculator {
    
    let numberConverter = NumberConverter()
    
    func calculate(statementString: String?) -> String {
        
        guard let statementString = statementString else { return "🤷" }
        
        let statement = transformedStatement(statementString)
        
        if let statement = statement.string  {
            let solvedStatement = solveStatement(statement)
            let truncatedSolvedStatement = floorNumber(solvedStatement)
            return numberConverter.convertToEmoji(from: truncatedSolvedStatement)
        } else if let error = statement.error {
            return "🤷 error: " + error.message
        } else {
            return "🤷"
        }
    }
    
    func calculateWithExpression(statementString: String) -> String {
        
        let statement = transformedStatement(statementString)
        
        if let statement = statement.string {
            let expresion = NSExpression(format: statement)
            let result = expresion.expressionValue(with: nil, context: nil) as? Int
            if let correctResult = result {
                let truncatedCorrectResult = floorNumber(String(correctResult))
                return numberConverter.convertToEmoji(from: truncatedCorrectResult)
            } else {
                return "🤷"
            }
        } else if let error = statement.error {
            return "🤷 error: " + error.message
        } else {
            return "🤷"
        }
    }
    
    //Mark: This method replaces all occurances of special operation symbols and numbers to regular symbols an numbers
    func transformedStatement(_ statement: String) -> (string: String?, error: Error?) {
        var modifiedStatement = statement
        
        Operation.allCases.forEach { operation in
            operation.stringOperations.forEach({
                modifiedStatement = modifiedStatement.replacingOccurrences(of: $0, with: operation.rawValue)
            })
        }
        modifiedStatement = modifiedStatement.replacingOccurrences(of: " ", with: "")
        
        for character in modifiedStatement {
            if let number = numberConverter.convertFromSymbol(String(character)) {
                modifiedStatement = modifiedStatement.replacingOccurrences(of: String(character), with: String(number))
            }
        }
        
        if let error = validate(statement: modifiedStatement) {
            return (nil, error)
        }
        return (modifiedStatement, nil)
    }
    
    // Validation to stop invalid statements
    func validate(statement: String) -> Error? {
        
        let allOperators = Operation.allCases.map({ $0.rawValue })
        
        if statement.isEmpty {
            return .statementIsEmpty
        }
        
        if statement.contains("/0") {
            return .divisionByZero
        }
        
        if let firstCharacter = statement.first, allOperators.contains(String(firstCharacter)) {
            return .startWithOperator
        }
        
        if let lastCharacter = statement.last, allOperators.contains(String(lastCharacter)) {
            return .endWithOperator
        }
        
        if isStatementInvalid(statement) {
            return .invalidStatement
        }
        
        if let number = isAnyNumberTooBig(statement) {
            return .numberIsTooBig(number: number)
        }
        
        for character in statement {
            if
            numberConverter.convertFromSymbol(String(character)) == nil
            && allOperators.contains(String(character)) == false
            && character != "." {
                return .invalidCharacter(character: String(character))
            }
        }
        return nil
    }
    
    func solveStatement(_ statement: String) -> String {
        var modifiedStatement = statement
        
        let operations: [[Operation]] = [[.multiplication, .division], [.addition, .substraction]]
        operations.forEach { operations in
            
            let occurances = statement.filter({ String($0) == operations[0].rawValue || String($0) == operations[1].rawValue }).count
            for _ in 0..<occurances {
                modifiedStatement = calculateOperations(operations, statement: modifiedStatement)
            }
        }
        return modifiedStatement
    }
    
    func calculateOperations(_ operations: [Operation], statement: String) -> String {
        
        // Find first statement f.e. 1+1 in 1+2-1
        let regexRange = NSRange(location: 0, length: statement.utf16.count)
        let operationsString = operations.map({ $0.rawValue }).joined()
        let pattern = "[0-9]+\\.?[0-9]*[\\\(operationsString)][0-9]+\\.?[0-9]*"
        let regex = try? NSRegularExpression(pattern: pattern)
        let match = regex?.firstMatch(in: statement, options: [], range: regexRange)
        
        if match == nil {
            return statement
        }
        
        let partlyStatementText = match.map { result -> String in
            if let range = Range(result.range, in: statement) {
                return String(statement[range])
            }
            return ""
        }
        
        let operation: Operation
        if partlyStatementText?.contains("*") ?? false {
            operation = .multiplication
        } else if partlyStatementText?.contains("/") ?? false {
            operation = .division
        } else if partlyStatementText?.contains("+") ?? false {
            operation = .addition
        } else if partlyStatementText?.contains("-") ?? false {
            operation = .substraction
        } else {
            return statement
        }
        
        let statementComponents = partlyStatementText?.components(separatedBy: operation.rawValue)
        // Separate to numbers f.e. 1 and 2
        guard
            let components = statementComponents,
            components.count == 2,
            let number1 = Double(components[0]),
            let number2 = Double(components[1]),
            let statementText = partlyStatementText,
            let statementRange = statement.range(of: statementText)
        else {
            return statement
        }
        
        // Do the operation, replace statement with result and return modified statement
        // F.e. solve 1+2 -> 3, replace 1+2-1 with 3-1
        let result = operation.doOperation(number1: number1, number2: number2)
        let resultString = String(result)
        let newStatement = statement.replacingCharacters(in: statementRange, with: resultString)
        
        return newStatement
    }
    
    func floorNumber(_ number: String) -> String {
        if let number = Double(number) {
            if number == floor(number) {
                return String(Int(number))
            }
        }
        return number
    }
    
    private func isStatementInvalid(_ statement: String) -> Bool {
        let regexRange = NSRange(location: 0, length: statement.utf16.count)
        let pattern = "[0-9]*[+\\-*/.]+[+\\-*/.]+[0-9]*"
        let regex = try? NSRegularExpression(pattern: pattern)
        let match = regex?.firstMatch(in: statement, options: [], range: regexRange)
        
        return match != nil
    }
    
    private func isAnyNumberTooBig(_ statement: String) -> String? {
        let regexRange = NSRange(location: 0, length: statement.utf16.count)
        let pattern = "[0-9]{8,}"
        let regex = try? NSRegularExpression(pattern: pattern)
        let match = regex?.firstMatch(in: statement, options: [], range: regexRange)
        
        if match == nil {
            return nil
        }
        
        let number = match.map { result -> String in
            if let range = Range(result.range, in: statement) {
                return String(statement[range])
            }
            return ""
        }
        return number
    }
}
