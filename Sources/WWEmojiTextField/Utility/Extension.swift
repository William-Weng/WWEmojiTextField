//
//  Extension.swift
//  WWEmojiTextField
//
//  Created by William.Weng on 2025/8/5.
//

import UIKit

// MARK: - NSMutableAttributedString (static)
extension NSMutableAttributedString {
    
    /// 建立NSMutableAttributedString
    /// - Parameters:
    ///   - attributedString: NSAttributedString?
    ///   - `default`: 預設值
    /// - Returns: NSMutableAttributedString
    static func _maker(_ attributedString: NSAttributedString?, `default`: String) -> NSMutableAttributedString {
        NSMutableAttributedString(attributedString: attributedString ?? NSAttributedString(string: ""))
    }
}

// MARK: - NSMutableAttributedString
extension NSMutableAttributedString {
    
    /// 取代文字
    /// - Parameters:
    ///   - range: 範圍
    ///   - cursorText: 要被取代的文字
    ///   - replaceText: 取代文字
    /// - Returns: 取代後的偏移量
    func _replaceCharacters(range: Range<String.Index>, in cursorText: String, with replaceText: String) -> Int {
        
        let replaceRange = range._NSRange(in: cursorText)
        let offset = replaceRange.location + replaceText.utf16.count

        replaceCharacters(in: replaceRange, with: replaceText)
        return offset
    }
}

// MARK: - Regex
extension Regex {
    
    /// [取出第一個符合的結果](https://onevcat.com/2022/11/swift-regex/)
    /// - Parameter string: [待測文字](https://www.appcoda.com.tw/swift-5-7-regex/)
    /// - Returns: Result<Regex<Output>.Match, Error
    func _firstMatch(in string: String) -> Result<Regex<Output>.Match, Error> {
        
        do {
            guard let match = try firstMatch(in: string) else { return .failure(WWEmojiTextField.CustomError.matchEmpty) }
            return .success(match)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Regex
extension Range where Bound == String.Index {
    
    /// Range => NSRange
    /// - Parameter string: StringProtocol
    /// - Returns: NSRange
    func _NSRange<S: StringProtocol>(in string : S) -> NSRange {
        return NSRange(self, in: string)
    }
}

// MARK: - UITextField
extension UITextField {
    
    /// 根據正規式規則替代文字
    /// - Parameters:
    ///   - regex: 正規式
    ///   - mapping: 替代文字群
    /// - Returns: Result<Bool, Error>
    func _convert(with regex: Regex<(Substring, Substring)>, mapping: [String: String]) -> Result<Bool, Error> {
        
        guard let selectedRange = self.selectedTextRange else { return .failure(WWEmojiTextField.CustomError.textRangeEmpty) }
        
        let cursorOffset = _offset(beginningWith: selectedRange.start)
        let attributedText = NSMutableAttributedString._maker(self.attributedText, default: "")
        let plainText = attributedText.string
        let cursorText = String(plainText.prefix(cursorOffset))
        
        switch regex._firstMatch(in: cursorText) {
        case .failure(let error): return .failure(error)
        case .success(let match):
            
            guard let replaceText = mapping[String(match.output.1).lowercased()] else { return .success(false) }
            
            let offset = attributedText._replaceCharacters(range: match.range, in: cursorText, with: replaceText)
            self.attributedText = attributedText
            
            if let newPosition = _position(beginningWith: offset) { _cursorPosition(newPosition) }
        }
        
        return .success(true)
    }
    
    /// 根據正規式規強調文字 (高亮)
    /// - Parameters:
    ///   - regex: 正規式
    ///   - mapping: 替代文字群
    ///   - color: 底色
    /// - Returns: Result<Bool, Error>
    func _highlight(with regex: Regex<(Substring, Substring)>, mapping: [String: String], color: UIColor) -> Result<Bool, Error> {
        
        guard let selectedRange = self.selectedTextRange else { return .failure(WWEmojiTextField.CustomError.textRangeEmpty) }

        let cursorOffset = _offset(beginningWith: selectedRange.start)
        let attributedText = NSMutableAttributedString(attributedString: self.attributedText ?? NSAttributedString(string: ""))
        let plainText = attributedText.string
        let cursorText = String(plainText.prefix(cursorOffset))

        attributedText.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: attributedText.length))

        defer {
            self.attributedText = attributedText
            if let originalPosition = self._position(beginningWith: cursorOffset) { _cursorPosition(originalPosition) }
        }
        
        switch regex._firstMatch(in: cursorText) {
        case .failure(let error): return .failure(error)
        case .success(let match):
            
            guard (mapping[String(match.output.1).lowercased()] != nil) else { return .success(false) }
            
            let keywordRange = NSRange(match.range, in: cursorText)
            attributedText.addAttribute(.backgroundColor, value: color, range: keywordRange)
        }
        
        return .success(true)
    }
    
    /// 設定游標位置 (一個長度為零的選取範圍)
    /// - Parameter position: UITextPosition
    func _cursorPosition(_ position: UITextPosition) {
        selectedTextRange = textRange(from: position, to: position)
    }
    
    /// 從文件開頭移動的偏移量
    /// - Parameter position: UITextPosition
    /// - Returns: Int
    func _offset(beginningWith position: UITextPosition) -> Int {
        return offset(from: beginningOfDocument, to: position)
    }
    
    /// 從文件結尾移動的偏移量
    /// - Parameter position: UITextPosition
    /// - Returns: Int
    func _offset(endWith position: UITextPosition) -> Int {
        return offset(from: endOfDocument, to: position)
    }
    
    /// 從文件開頭移動
    /// - Parameter offset: Int
    /// - Returns: UITextPosition?
    func _position(beginningWith offset: Int) -> UITextPosition? {
        return position(from: beginningOfDocument, offset: offset)
    }
    
    /// 從文件結尾移動 (倒著算)
    /// - Parameter offset: Int
    /// - Returns: UITextPosition?
    func _position(endWith offset: Int) -> UITextPosition? {
        return position(from: endOfDocument, offset: offset)
    }
}
