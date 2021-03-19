//
//  NumberConverter.swift
//  EmojiCalculator
//
//  Created by Ondrej Andrysek on 3/16/21.
//

import Foundation

struct NumberConverter {
    
    func convertFromSymbol(_ symbol: String) -> Int? {
        
        let string: String
        if let unicodeScalar = symbol.unicodeScalars.first, ("0"..."9").contains(String(unicodeScalar)) {
            string = String(unicodeScalar)
        } else {
            string = symbol
        }

        switch string {
            case "0"..."9":     return Int(string)
            case "🎱":          return 8
            case "🔟":          return 10
            case "💯":          return 100
            default:            return nil
        }
    }
    
    func convertToEmoji(from solution: String) -> String {
        var string = solution
        [(symbol: "💯", value: "100"), (symbol: "🔟", value: "10")].forEach({
            string = string.replacingOccurrences(of: $0.value, with: $0.symbol)
        })
        
        for number in 0...9 {
            string = string.replacingOccurrences(of: "\(number)", with: emojiNumber(from: number))
        }
        
        return string
    }
    
    private func emojiNumber(from number: Int) -> String {
        return "\(number)\u{FE0F}"
    }
}
