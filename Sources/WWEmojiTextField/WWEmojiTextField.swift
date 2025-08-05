//
//  WWEmojiTextField.swift
//  WWEmojiTextField
//
//  Created by William.Weng on 2025/8/5.
//

import UIKit

// MARK: - 一個簡單把輸入單字轉成顏文字符號的文字框
open class WWEmojiTextField: UITextField {

    public var emojiDelegate: WWEmojiTextField.Delegate?
    
    private var mapping = [String: String]()
    private var convertRegex: Regex<(Substring, Substring)> = try! Regex("\\((\\w+)\\s$")
    private var highlightRegex: Regex<(Substring, Substring)> = try! Regex("\\((\\w+)$")
    private var highlightColor: UIColor = .lightGray
}

// MARK: - WWEmojiTextField (public)
public extension WWEmojiTextField {
    
    /// [初始設定](https://www.appcoda.com.tw/swift4-changes/)
    /// - Parameters:
    ///   - mapping: 對映的JSON檔
    ///   - highlightColor: 強調文字的底色
    ///   - convertRegex: 轉換文字的正規式
    ///   - highlightRegex: 強調文字的正規式
    func configure(mapping: [String: String], highlightColor: UIColor = .lightGray, convertRegex: Regex<(Substring, Substring)> = try! Regex("\\((\\w+)\\s$"), highlightRegex: Regex<(Substring, Substring)> = try! Regex("\\((\\w+)$")) {
        
        self.mapping = mapping
        self.highlightColor = highlightColor
        self.convertRegex = convertRegex
        self.highlightRegex = highlightRegex
        
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

// MARK: - WWEmojiTextField (private @objc)
private extension WWEmojiTextField {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        emojiDelegate?.didChange(textField: self)
        convertToEmoji(textField: textField)
    }
}

// MARK: - WWEmojiTextField (private)
private extension WWEmojiTextField {
    
    /// 轉換Emoji
    /// - Parameter textField: UITextField
    func convertToEmoji(textField: UITextField) {
        
        let result1 = textField._convert(with: convertRegex, mapping: mapping)
        let result2 = textField._highlight(with: highlightRegex, mapping: mapping, color: highlightColor)
        
        emojiDelegate?.convert(textField: self, result: result1)
        emojiDelegate?.highlight(textField: self, result: result2)
    }
}
