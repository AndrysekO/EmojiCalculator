//
//  main.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/16/21.
//

import Foundation

let calculator = Calculator()

print(calculator.calculate(statementString:"4️2️ + 🎱+25✖️2"))
print(calculator.calculate(statementString:"4️2"))
print(calculator.calculate(statementString:"100✖💯"))
print(calculator.calculate(statementString:"8️✖🎱"))
print(calculator.calculate(statementString:"🔟x🔟"))
print(calculator.calculate(statementString:"1 plus 1"))
print(calculator.calculate(statementString:"1%0"))

func start() {
    print("Statement: ")
    let input = readLine()
    print(calculator.calculate(statementString: input))
    start()
}

start()


