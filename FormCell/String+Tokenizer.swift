//
//  String+Tokenizer.swift
//  FormCell
//
//  Created by 須藤 将史 on 2017/03/11.
//  Copyright © 2017年 masashi_sutou. All rights reserved.
//

import Foundation

extension String {
    
    // use only Japanaese
    
    public func hiraganaToKatakana() -> String {
        
        guard let prefLang = Locale.preferredLanguages.first else { return self }
        if prefLang.hasPrefix("ja") {
            if let kana = self.applyingTransform(.hiraganaToKatakana, reverse: false) {
                return kana
            } else {
                return self
            }
        } else {
            return self
        }
    }
    
    // use only Japanaese
    
    public func katakanaFurigana() -> String {
        
        guard let prefLang = Locale.preferredLanguages.first else { return "" }
        if prefLang.hasPrefix("ja") {
            
            let inputText: NSString = self as NSString
            let furigana = NSMutableString()
            
            let range: CFRange = CFRangeMake(0, inputText.length)
            let locale: CFLocale = CFLocaleCopyCurrent()
            let tokenizer: CFStringTokenizer = CFStringTokenizerCreate(kCFAllocatorDefault, inputText as CFString, range, kCFStringTokenizerUnitWordBoundary, locale)
            
            var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0)
            
            while tokenType != CFStringTokenizerTokenType(rawValue: 0) {
                let latin: CFTypeRef = CFStringTokenizerCopyCurrentTokenAttribute(tokenizer, kCFStringTokenizerAttributeLatinTranscription)
                
                guard let romanAlphabet: NSMutableString = latin as? NSMutableString else { continue }
                CFStringTransform(romanAlphabet as CFMutableString, nil, kCFStringTransformLatinHiragana, false)
                
                furigana.append(romanAlphabet as String)
                tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer)
            }
            
            let outputText: String = furigana as String
            return outputText.hiraganaToKatakana()
            
        } else {
            return ""
        }
    }
}
