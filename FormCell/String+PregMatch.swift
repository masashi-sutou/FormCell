//
//  String+PregMatch.swift
//  FormCell
//
//  Created by 須藤 将史 on 2017/03/05.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import Foundation

public enum PregMatchePattern: String {
    case kana = "^[ァ-ヾ]+$"
    case postal = "^\\d{7}$"
    case phone = "^\\d{10,11}$"
    case phoneHyphen = "^\\d{2,4}-\\d{2,4}-\\d{3,4}$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    public func errorMessage() -> String {
        
        switch self {
        case .kana:
            return "Please enter Katakana"
        case .postal:
            return "Invalid format postal code"
        case .phone:
            return "Invalid format phone number in Japan"
        case .phoneHyphen:
            return "Invalid format hyphen phone number in Japan"
        case .email:
            return "Invalid format mail address"
        }
    }
}

public extension String {
    
    func pregMatche(pattern: PregMatchePattern, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern.rawValue, options: options) else {
            return false
        }
        
        if pattern == .email && !self.canBeConverted(to: .ascii) {
            return false
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.characters.count))
        return matches.count > 0
    }
}
